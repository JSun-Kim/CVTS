class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.boolean :finished
      t.boolean :approved
      t.references :ballot

      t.timestamps
    end
    add_index :notifications, :ballot_id
  end
end
