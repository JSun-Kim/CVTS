class CreateCvotes < ActiveRecord::Migration
  def change
    create_table :cvotes do |t|
      t.integer :ballot_id
      t.integer :user_id
      t.boolean :approval

      t.timestamps
    end
  end
end
