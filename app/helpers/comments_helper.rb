module CommentsHelper
  def nested_comments(comments)
    comment_community_ids = []

    @user = current_user
    community_ids = []
    selectedmemberships = Membership.find(:all, :conditions => {:selected => true, :user_id => current_user.id} )
    
    for membership in selectedmemberships
      community_ids.push(membership.community_id)
    end
    @user_communities = Community.find(:all, :conditions => ["id IN (?)", community_ids]) #<==used in view

  	unless comments.nil? || comments.empty?
	    comments.map do |comment, sub_comments|
        comment_annotations = CommentAnnotation.find(:all, :conditions => {:comment_id => comment.id} )
        for annotation in comment_annotations
          comment_community_ids.push(annotation.community_id)
        end
        @commnent_communities = Community.find(:all, :conditions => ["id IN (?)", comment_community_ids]) #<== used in view
        @user_comment_intersect_communities = @user_communities & @commnent_communities
       
        @comment_user = User.find(:first, :conditions => {:id => comment.user_id})

        unless @user_comment_intersect_communities.nil?  || @user_comment_intersect_communities.empty?
          content_tag(:div, :class => "nested_comments") do
            render(comment) + nested_comments(sub_comments)
          end
        end
	    end.join.html_safe
	end
  end
  #
  #if type == 0, intersect story's communities with user's communities
  #if type == 1, intersect comment's communities with user's communities
  def intersected_communities(type, message, user_communities)
    annotations = []
  	if type == 0 #message_id is story_id
  		annotations = Annotation.find(:all, :conditions => ["story_id = ?", message.id.to_s]) 
  	elsif type == 1 #message_id is comment_id
  		annotations = CommentAnnotation.find(:all, :conditions => ["comment_id = ?", message.id]) 
  	end
  	sel_communities = []
    
    results = []
    for annotation in annotations
      unless annotation.community_id.nil?
        @found_community = Community.find(:first, :conditions => "id = " + annotation.community_id.to_s)
        if @found_community.name != 'Public'  
          sel_communities << @found_community
        else
          sel_communities = Community.find(:all)
        end
      end
    end

    user_community_ids = []
    for user_community in user_communities
      user_community_ids << user_community.id
    end

    sel_community_ids = []
    unless sel_communities.nil? || sel_communities.empty?
      for sel_community in sel_communities
        sel_community_ids << sel_community.id
      end
    end
    result_ids = user_community_ids & sel_community_ids
    results = Community.find(:all, :conditions => ["id IN (?)", result_ids])
    return results
  end
end