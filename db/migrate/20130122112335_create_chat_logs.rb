class CreateChatLogs < ActiveRecord::Migration
  def change
    create_table :chat_logs do |t|
      t.text :log
      t.integer :room_id
      t.integer :user_id

      t.timestamps
    end
  end
end
