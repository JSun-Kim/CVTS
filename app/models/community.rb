class Community < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  scope :archived_communities, :conditions => {:archived => true}
  scope :current_communities, :conditions => {:archived => false}

  def self.intersection(story)
  	intersection_list = []

  	story.communities.each do |c|
  		intersection_list = c.users | intersection_list
  	end

  	story.communities.each do |c|
  		intersection_list = c.users & intersection_list
  	end

  	return intersection_list
  end

def to_s
	name
end

# name autocomplete: public/javascripts/tiny_mce/plugins/searchreplace
def self.autocomplete(search)
  if search
    find(:all, :conditions => ['name LIKE ?', "#{search}%"])
  else
    find(:all)
  end 
end

  has_many :memberships
  has_many :users, :through => :memberships, :uniq => true
  accepts_nested_attributes_for :memberships #KJS

  has_many :annotations
  has_many :stories, :through => :annotations, :uniq => true
  has_many :ballots, :as => :myballots
end