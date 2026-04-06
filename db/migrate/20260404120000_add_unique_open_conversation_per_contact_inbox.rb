# frozen_string_literal: true

# Enforces at most one open conversation (status enum value 0) per (contact_id, inbox_id).
# If this fails with a unique violation, dedupe existing open rows for the same pair before retrying.
class AddUniqueOpenConversationPerContactInbox < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :conversations, %i[contact_id inbox_id],
              unique: true,
              where: 'status = 0',
              name: 'index_conversations_open_unique_per_contact_and_inbox',
              algorithm: :concurrently
  end
end
