require 'rails_helper'

describe ConversationBuilder do
  let(:account) { create(:account) }
  let!(:sms_channel) { create(:channel_sms, account: account) }
  let!(:api_channel) { create(:channel_api, account: account) }
  let!(:sms_inbox) { create(:inbox, channel: sms_channel, account: account) }
  let!(:api_inbox) { create(:inbox, channel: api_channel, account: account) }
  let(:contact) { create(:contact, account: account) }
  let(:contact_sms_inbox) { create(:contact_inbox, contact: contact, inbox: sms_inbox) }
  let(:contact_api_inbox) { create(:contact_inbox, contact: contact, inbox: api_inbox) }

  describe '#perform' do
    it 'creates sms conversation' do
      conversation = described_class.new(
        contact_inbox: contact_sms_inbox,
        params: {}
      ).perform

      expect(conversation.contact_inbox_id).to eq(contact_sms_inbox.id)
    end

    it 'creates api conversation' do
      conversation = described_class.new(
        contact_inbox: contact_api_inbox,
        params: {}
      ).perform

      expect(conversation.contact_inbox_id).to eq(contact_api_inbox.id)
    end

    context 'when lock_to_single_conversation is true for sms inbox' do
      before do
        sms_inbox.update!(lock_to_single_conversation: true)
      end

      it 'creates sms conversation when existing conversation is not present' do
        conversation = described_class.new(
          contact_inbox: contact_sms_inbox,
          params: {}
        ).perform

        expect(conversation.contact_inbox_id).to eq(contact_sms_inbox.id)
      end

      it 'returns last from existing sms conversations when existing conversation is not present' do
        create(:conversation, contact_inbox: contact_sms_inbox, status: :resolved)
        existing_conversation = create(:conversation, contact_inbox: contact_sms_inbox, status: :open)
        conversation = described_class.new(
          contact_inbox: contact_sms_inbox,
          params: {}
        ).perform

        expect(conversation.id).to eq(existing_conversation.id)
      end
    end

    context 'when lock_to_single_conversation is true for api inbox' do
      before do
        api_inbox.update!(lock_to_single_conversation: true)
      end

      it 'creates conversation when existing api conversation is not present' do
        conversation = described_class.new(
          contact_inbox: contact_api_inbox,
          params: {}
        ).perform

        expect(conversation.contact_inbox_id).to eq(contact_api_inbox.id)
      end

      it 'returns last from existing api conversations when existing conversation is not present' do
        create(:conversation, contact_inbox: contact_api_inbox, status: :resolved)
        existing_conversation = create(:conversation, contact_inbox: contact_api_inbox, status: :open)
        conversation = described_class.new(
          contact_inbox: contact_api_inbox,
          params: {}
        ).perform

        expect(conversation.id).to eq(existing_conversation.id)
      end
    end

    context 'when an open conversation already exists for the same contact and inbox' do
      let(:assignee) { create(:user, account: account, role: :agent, name: 'Maria Silva') }

      before do
        create(
          :conversation,
          account: account,
          inbox: sms_inbox,
          contact: contact,
          contact_inbox: contact_sms_inbox,
          status: :open,
          assignee: assignee
        )
      end

      it 'does not create a second open conversation and mentions the assignee' do
        expect do
          described_class.new(contact_inbox: contact_sms_inbox, params: {}).perform
        end.to raise_error(ActiveRecord::RecordInvalid) do |e|
          expect(e.record.errors[:base].first).to include('Maria Silva')
        end
      end
    end

    context 'when the previous conversation is resolved' do
      before do
        create(
          :conversation,
          account: account,
          inbox: sms_inbox,
          contact: contact,
          contact_inbox: contact_sms_inbox,
          status: :resolved
        )
      end

      it 'creates a new open conversation' do
        conversation = described_class.new(
          contact_inbox: contact_sms_inbox,
          params: {}
        ).perform

        expect(conversation).to be_open
        expect(conversation.contact_inbox_id).to eq(contact_sms_inbox.id)
      end
    end

    context 'when the previous conversation is snoozed' do
      before do
        create(
          :conversation,
          account: account,
          inbox: sms_inbox,
          contact: contact,
          contact_inbox: contact_sms_inbox,
          status: :snoozed,
          snoozed_until: 1.day.from_now
        )
      end

      it 'creates a new open conversation' do
        conversation = described_class.new(
          contact_inbox: contact_sms_inbox,
          params: {}
        ).perform

        expect(conversation).to be_open
        expect(conversation.contact_inbox_id).to eq(contact_sms_inbox.id)
      end
    end
  end
end
