class CreateInboxMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :inbox_messages do |t|
      t.string :from
      t.string :subject
      t.text :message
      t.string :message_id
      t.string :status
      t.datetime :sent_at

      t.timestamps
    end
  end
end
