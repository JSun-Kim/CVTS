class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.references :community
      t.references :story

      t.timestamps
    end
    add_index :annotations, :community_id
    add_index :annotations, :story_id
  end
end
