class Api::V1::Accounts::InternalChatController < Api::V1::Accounts::BaseController
  before_action :set_internal_conversation, only: [:show, :messages, :create_message, :update_message, :destroy_message, :read_conversation]

  def index
    @conversations = Current.account.conversations
                              .where(internal: true)
                              .where("additional_attributes->'participant_ids' @> ?", [Current.user.id].to_json)
                              .includes([{ assignee: { avatar_attachment: [:blob] } },
                                         { contact: { avatar_attachment: [:blob] } }])
                              .order(last_activity_at: :desc)
                              .limit(50)
    render json: @conversations.map { |c| serialize_conversation(c) }
  end

  def create
    participant_ids = params[:user_ids].map(&:to_i) + [Current.user.id]
    participant_ids.uniq!

    inbox = find_or_create_internal_inbox
    contact = find_or_create_internal_contact
    contact_inbox = find_or_create_internal_contact_inbox(inbox, contact)

    # Check if conversation already exists with these exact participants
    sorted_ids = participant_ids.sort
    existing_conv = Current.account.conversations
                           .where(internal: true)
                           .where("additional_attributes->'participant_ids' @> ?", sorted_ids.to_json)
                           .detect { |c| (c.additional_attributes&.dig('participant_ids') || []).sort == sorted_ids }

    if existing_conv
      @conversation = existing_conv
    else
      @conversation = Current.account.conversations.new(
        account_id: Current.account.id,
        inbox_id: inbox.id,
        contact_id: contact.id,
        contact_inbox_id: contact_inbox.id,
        internal: true,
        status: :open,
        last_activity_at: Time.current,
        additional_attributes: { type: 'internal', participant_ids: participant_ids }
      )
      @conversation.skip_open_duplicate_validation = true
      @conversation.save!
    end

    if params[:message].present?
      message = @conversation.messages.create!(
        account_id: Current.account.id,
        inbox_id: inbox.id,
        content: params[:message],
        message_type: :internal,
        sender: Current.user,
        sender_type: 'User'
      )
      @conversation.update!(last_activity_at: Time.current)
      broadcast_message(message, :created)
    end

    render json: serialize_conversation(@conversation)
  end

  def show
    render json: serialize_conversation(@conversation)
  end

  def messages
    # Retorna as 100 mensagens internas mais recentes, em ordem de exibição (antiga → nova).
    # NOTA 1 (v4.14.6): `.reverse` num ActiveRecord::Relation é no-op — nunca usar.
    # NOTA 2 (v4.14.8): usar `.reorder` e NÃO `.order` — o model Message tem
    # `default_scope { order(created_at: :asc) }`, que ANULA o `.order(created_at: :desc)`
    # (em Rails, order() acrescenta, não substitui) e fazia o `limit(100)` retornar as
    # 100 MAIS ANTIGAS → em conversas com >100 msgs, as novas sumiam (bug da conversa de 2
    # pessoas, 4480). `.reorder` SUBSTITUI o default_scope.
    latest_ids = @conversation.messages
                              .where(message_type: :internal)
                              .reorder(created_at: :desc)
                              .limit(100)
                              .pluck(:id)
    @messages = @conversation.messages
                              .where(message_type: :internal, id: latest_ids)
                              .includes(:sender)
                              .reorder(created_at: :asc)
    render json: @messages.map { |m| serialize_message(m) }
  end

  def create_message
    @message = @conversation.messages.create!(
      account_id: Current.account.id,
      inbox_id: @conversation.inbox_id,
      content: params[:content] || params[:message]&.dig(:content),
      message_type: :internal,
      sender: Current.user,
      sender_type: 'User'
    )

    # Handle file attachments
    if params[:attachments].present?
      params[:attachments].each do |attachment|
        @message.attachments.create!(
          account_id: Current.account.id,
          file: attachment
        )
      end
    end

    @conversation.update!(last_activity_at: Time.current)
    broadcast_message(@message, :created)

    render json: serialize_message(@message)
  end

  def update_message
    message = @conversation.messages.find(params[:message_id])
    return render json: { error: 'Message not found' }, status: :not_found if message.blank?
    return render json: { error: 'Message can no longer be edited' }, status: :unprocessable_entity unless message.editable?
    return render json: { error: 'You can only edit your own messages' }, status: :forbidden unless message.sender_id == Current.user.id

    message.mark_edited!(params[:content])
    broadcast_message(message, :updated)

    render json: serialize_message(message)
  end

  def destroy_message
    message = @conversation.messages.find(params[:message_id])
    return render json: { error: 'Message not found' }, status: :not_found if message.blank?
    return render json: { error: 'Message can no longer be deleted' }, status: :unprocessable_entity unless message.deletable?
    return render json: { error: 'You can only delete your own messages' }, status: :forbidden unless message.sender_id == Current.user.id

    message.update!(
      content: I18n.t('conversations.messages.deleted'),
      content_type: :text,
      content_attributes: message.content_attributes.merge(deleted: true)
    )
    message.attachments.destroy_all
    broadcast_message(message, :deleted)

    render json: serialize_message(message)
  end

  def users
    @users = Current.account.users.order(:name)
    current_user_id = Current.user.id

    # Find all participant IDs from internal conversations where current user participates
    existing_participant_ids = Current.account.conversations
                                     .where(internal: true)
                                     .where("additional_attributes->'participant_ids' @> ?", [current_user_id].to_json)
                                     .pluck(:additional_attributes)
                                     .filter_map { |attrs| attrs&.dig('participant_ids') }
                                     .flatten
                                     .uniq

    render json: @users.map { |u|
      {
        id: u.id,
        name: u.name,
        email: u.email,
        avatar_url: u.avatar_url,
        has_open_chat: existing_participant_ids.include?(u.id) && u.id != current_user_id
      }
    }
  end

  def read_conversation
    @conversation.messages.where(message_type: :internal).where.not(sender_id: Current.user.id).each do |msg|
      read_by = msg.content_attributes['read_by'] || []
      next if read_by.include?(Current.user.id)

      read_by << Current.user.id
      msg.update!(content_attributes: msg.content_attributes.merge('read_by' => read_by))
    end
    render json: { status: 'ok' }
  end

  def unread_count
    count = Current.account.notifications
                     .where(user_id: Current.user.id)
                     .where(notification_type: :assigned_conversation_new_message)
                     .where(read_at: nil)
                     .where(primary_actor_type: 'Conversation')
                     .joins('INNER JOIN conversations ON notifications.primary_actor_id = conversations.id')
                     .where(conversations: { internal: true })
                     .count
    render json: { unread_count: count }
  end

  def mark_read
    Current.account.notifications
           .where(user_id: Current.user.id)
           .where(notification_type: :assigned_conversation_new_message)
           .where(read_at: nil)
           .where(primary_actor_type: 'Conversation')
           .joins('INNER JOIN conversations ON notifications.primary_actor_id = conversations.id')
           .where(conversations: { internal: true })
           .update_all(read_at: Time.current)
    render json: { status: 'ok' }
  end

  def inbox_id
    inbox = Current.account.inboxes.find_by(name: 'Chat Interno')
    if inbox.blank?
      # Create on demand
      channel = Channel::Api.create!(account: Current.account)
      inbox = Current.account.inboxes.create!(
        name: 'Chat Interno',
        channel: channel,
        enable_auto_assignment: false
      )
      # Add all users
      Current.account.users.each do |user|
        inbox.inbox_members.find_or_create_by!(user_id: user.id)
      end
    end
    render json: { inbox_id: inbox.id, name: 'Chat Interno' }
  end

  private

  def set_internal_conversation
    @conversation = Current.account.conversations
                            .where(internal: true)
                            .where("additional_attributes->'participant_ids' @> ?", [Current.user.id].to_json)
                            .find(params[:id])
  end

  def find_or_create_internal_inbox
    inbox = Current.account.inboxes.find_by(name: 'Chat Interno')
    return inbox if inbox.present?

    channel = Channel::Api.create!(account: Current.account)
    Current.account.inboxes.create!(
      name: 'Chat Interno',
      channel: channel,
      enable_auto_assignment: false
    )
  end

  def find_or_create_internal_contact
    contact = Current.account.contacts.find_by(identifier: 'internal_system')
    return contact if contact.present?

    Current.account.contacts.create!(
      name: 'Chat Interno',
      identifier: 'internal_system',
      phone_number: '+5500000000000'
    )
  end

  def find_or_create_internal_contact_inbox(inbox, contact)
    ContactInbox.find_or_create_by!(
      contact: contact,
      inbox: inbox,
      source_id: 'internal_chat'
    )
  end

  def broadcast_message(message, event_type)
    return unless event_type == :created

    participant_ids = @conversation.additional_attributes&.dig('participant_ids') || []
    sender_id = message.sender_id

    # Create notifications for all participants (except sender).
    # Email/push delivery follows each user's notification preference — do NOT
    # force-enable their email/push flags here (that was re-checking the
    # "Uma nova mensagem foi criada e atribuída" preference on every message).
    Current.account.users.where(id: participant_ids).where.not(id: sender_id).each do |user|
      user.notifications.create!(
        notification_type: :assigned_conversation_new_message,
        account: Current.account,
        primary_actor: @conversation,
        secondary_actor: message
      )
    end

    # Broadcast real-time update via ActionCable
    tokens = Current.account.users.where(id: participant_ids).where.not(id: sender_id).pluck(:pubsub_token).compact.uniq
    return if tokens.blank?

    ::ActionCableBroadcastJob.perform_later(
      tokens,
      'message.created',
      {
        id: message.id,
        content: message.content,
        conversation_id: @conversation.display_id,
        message_type: :internal,
        created_at: message.created_at.to_i,
        sender: message.sender.is_a?(User) ? message.sender.push_event_data : nil,
        account_id: Current.account.id
      }
    )
  end

  def serialize_conversation(conv)
    participant_ids = conv.additional_attributes&.dig('participant_ids') ||
                      conv.messages.where(message_type: :internal).pluck(:sender_id).uniq
    participants = Current.account.users.where(id: participant_ids).map { |u|
      { id: u.id, name: u.name, email: u.email, avatar_url: u.avatar_url }
    }
    last_msg = conv.messages.where(message_type: :internal).last

    {
      id: conv.id,
      display_id: conv.display_id,
      last_activity_at: conv.last_activity_at.to_i,
      created_at: conv.created_at.to_i,
      participants: participants,
      participant_ids: participant_ids,
      last_message: last_msg ? serialize_message(last_msg) : nil
    }
  end

  def serialize_message(msg)
    {
      id: msg.id,
      content: msg.content,
      message_type: msg.message_type,
      created_at: msg.created_at.to_i,
      edited_at: msg.edited_at&.to_i,
      edited: msg.content_attributes[:edited],
      deleted: msg.content_attributes[:deleted],
      read_by: msg.content_attributes['read_by'] || [],
      sender: msg.sender.is_a?(User) ? {
        id: msg.sender.id,
        name: msg.sender.name,
        email: msg.sender.email,
        avatar_url: msg.sender.avatar_url
      } : nil,
      conversation_id: msg.conversation.display_id,
      attachments: msg.attachments.map { |a|
        {
          id: a.id,
          file_url: url_for(a.file),
          file_type: a.file.content_type,
          file_size: a.file.byte_size,
          file_name: a.file.filename.to_s
        }
      }
    }
  end
end
