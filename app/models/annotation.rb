class Annotation < ActiveRecord::Base
  belongs_to :community
  belongs_to :story
  attr_accessible :community_id, :story_id
  # attr_accessible :title, :body
end
