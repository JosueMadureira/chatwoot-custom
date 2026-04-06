class ConversationBuilder
  pattr_initialize [:params!, :contact_inbox!]

  def perform
    look_up_exising_conversation || create_new_conversation
  end

  private

  def look_up_exising_conversation
    return unless @contact_inbox.inbox.lock_to_single_conversation?

    @contact_inbox.conversations.last
  end

  def create_new_conversation
    @contact_inbox.with_lock do
      begin
        ::Conversation.create!(conversation_params)
      rescue ActiveRecord::RecordNotUnique => e
        raise e unless ::Conversation.open_contact_inbox_unique_violation?(e)

        existing = find_open_conversation_for_contact_inbox
        raise e if existing.blank?

        log_duplicate_attempt(existing)
        raise ::CustomExceptions::Conversation::OpenConversationExists,
              ::Conversation.open_duplicate_error_message(existing)
      end
    end
  end

  def find_open_conversation_for_contact_inbox
    ::Conversation.includes(:assignee, :assignee_agent_bot).find_by(
      contact_id: @contact_inbox.contact_id,
      inbox_id: @contact_inbox.inbox_id,
      status: :open
    )
  end

  def log_duplicate_attempt(existing)
    Rails.logger.info(
      "[ConversationBuilder] Tentativa de conversa open duplicada — account_id: #{@contact_inbox.inbox.account_id}, " \
      "contact_id: #{@contact_inbox.contact_id}, inbox_id: #{@contact_inbox.inbox_id}, " \
      "conversa_existente_id: #{existing&.id}, assignee_id: #{existing&.assignee_id}"
    )
  end

  def conversation_params
    additional_attributes = params[:additional_attributes]&.permit! || {}
    custom_attributes = params[:custom_attributes]&.permit! || {}
    status = params[:status].present? ? { status: params[:status] } : {}

    # TODO: temporary fallback for the old bot status in conversation, we will remove after couple of releases
    # commenting this out to see if there are any errors, if not we can remove this in subsequent releases
    # status = { status: 'pending' } if status[:status] == 'bot'
    {
      account_id: @contact_inbox.inbox.account_id,
      inbox_id: @contact_inbox.inbox_id,
      contact_id: @contact_inbox.contact_id,
      contact_inbox_id: @contact_inbox.id,
      additional_attributes: additional_attributes,
      custom_attributes: custom_attributes,
      snoozed_until: params[:snoozed_until],
      assignee_id: params[:assignee_id],
      team_id: params[:team_id]
    }.merge(status)
  end
end
