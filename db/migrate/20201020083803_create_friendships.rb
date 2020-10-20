class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :sent_to, foreign_key: { to_table: :users }
      t.references :sent_by, foreign_key: { to_table: :users }
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
