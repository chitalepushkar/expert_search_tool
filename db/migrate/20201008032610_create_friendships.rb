class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.integer :request_sender_id, references: :user, unsigned: true, null: false
      t.integer :request_receiver_id, references: :user, unsigned: true, null: false

      t.timestamps
    end
    add_index :friendships, [:request_sender_id, :request_receiver_id], unique: true
  end
end
