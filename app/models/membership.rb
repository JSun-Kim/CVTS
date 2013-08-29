class Membership < ActiveRecord::Base
  belongs_to :community
  belongs_to :user
  attr_accessible :selected, :community_id, :user_id
  # attr_accessible :title, :body

  def self.select_communities(membership)
  	membership.update_attributes(:selected => true)
  end

  def self.unselect_communities(membership)
  	membership.update_attributes(:selected => false)
  end

  def self.selected? (membership)
  	membership.selected
  end
end
