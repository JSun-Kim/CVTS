class CommentAnnotation < ActiveRecord::Base
  belongs_to :community
  belongs_to :comment
  attr_accessible :community_id, :story_id
  # attr_accessible :title, :body
end
