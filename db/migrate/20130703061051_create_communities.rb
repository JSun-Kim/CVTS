class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name
      t.text :description
      t.boolean :approved
      t.boolean :archived
      t.boolean :voteable

      t.timestamps
    end
  end
end
