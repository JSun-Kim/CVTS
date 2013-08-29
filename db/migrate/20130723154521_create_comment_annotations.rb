class CreateCommentAnnotations < ActiveRecord::Migration
  def change
    create_table :comment_annotations do |t|
      t.references :community
      t.references :comment

      t.timestamps
    end
    add_index :comment_annotations, :community_id
    add_index :comment_annotations, :comment_id
  end
end
