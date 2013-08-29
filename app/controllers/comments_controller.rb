class CommentsController < ApplicationController
  #KJS. added for nested comments
  #new action is called when add a comment to a comment
  
  def new 
    if logged_in?
      @parent_id = params.delete(:parent_id)
      @commentable = find_commentable
      @comment = Comment.new( :parent_id => @parent_id, 
                              :commentable_id => @commentable.id,
                              :commentable_type => @commentable.class.to_s)

      @parent_comment = Comment.find(@parent_id)

      @comment_user = User.find(:first, :conditions => {:id => @parent_comment.user_id})

      comment_community_ids = []
      comment_annotations = CommentAnnotation.find(:all, :conditions => {:comment_id => @parent_id} )
      for annotation in comment_annotations
        comment_community_ids.push(annotation.community_id)
      end
      @commnent_communities = Community.find(:all, :conditions => ["id IN (?)", comment_community_ids])
    end
  end

  def create
    if logged_in?
      @commentable = find_commentable
      @comment = @commentable.comments.build(params[:comment])
      #from check-boxes
      selected_ids = [] 
      if params[:community_ids]
        selected_ids = params[:community_ids].collect {|id| id.to_i} 
      end
      @parent_id = @comment.parent_id

      story_annotations = []
      
      if selected_ids.empty?
        unless @parent_id.nil?
          story_annotations = CommentAnnotation.find(:all, :conditions => {:comment_id => @parent_id})
        else
          story_annotations = Annotation.find(:all, :conditions => {:story_id => @commentable.id} )

        end
      end
      unless story_annotations.nil?
        for annotation in story_annotations
            selected_ids.push(annotation.community_id)
        end
      end

      if @comment.save
        unless selected_ids.nil? || selected_ids.empty?
          selected_ids.each do |sel_id|
            @comment_association = CommentAnnotation.new
            @comment_association.comment_id =  @comment.id
            @comment_association.community_id = sel_id
            @comment_association.save
          end
        end
        @comment.user_id = current_user.id
        @comment.story_id = @commentable.id
        @comment.save

      # increment story popularity
        story = Story.find(params[:story_id])
        story.increase_popularity(Story::ScoreComment)
        story.save

        flash[:notice] = "Successfully created comment."
        redirect_to @commentable
      else
        flash[:error] = "Error adding comment."
      end
    else
      # todo: send back error response
    end
  end

  def destroy
    if logged_in?
      @comment = Comment.find(params[:id])
      @comment.communities.delete_all #CommentAnnotation
      @comment.destroy
      if @comment.user == current_user
        @comment.story.decrease_popularity(Story::ScoreComment)
        @comment.story.save
      end
      redirect_back_or(root_url)
    end
  end

  private
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end