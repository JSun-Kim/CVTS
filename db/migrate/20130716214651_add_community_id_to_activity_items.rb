class AddCommunityIdToActivityItems < ActiveRecord::Migration
  def change
    add_column :activity_items, :community_id, :integer
  end
end
