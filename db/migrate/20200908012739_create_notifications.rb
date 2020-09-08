class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :destination_id
      t.integer :follow_id
      t.integer :variety
      t.text :content
      t.integer :from_user_id

      t.timestamps
    end
  end
end
