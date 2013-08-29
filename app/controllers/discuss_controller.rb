require 'will_paginate/array'

class DiscussController < ApplicationController
  def index
    @page_title = "Discuss"

    # get the recent activities
    activities = ActivityItem.find :all, :order => "created_at DESC", :include => :comment

    @stories = []
    @story_activities = Hash.new
    for activity in activities
      if activity.kind == ActivityItem::CommentType or
          activity.kind == ActivityItem::CreatePostType
        if !@story_activities.has_key?(activity.story_id)
          @story_activities[activity.story_id] = [activity]
          @stories.push(Story.find(activity.story_id))
        else
          @story_activities[activity.story_id].push(activity)
        end
      end
    end

    @comments = Hash.new

    @stories.each do |story|
      @comments[story.id] = []
      story.comments.each do |comment|
        @comments[story.id].push({
          :id               => comment.id,
          :body             => comment.body,
          :user_login       => comment.user.login,
          :user_email_hash  => Digest::MD5.hexdigest(comment.user.email),
          :user_id          => comment.user.id,
          :timestamp        => comment.created_at
        })
      end
    end
    if @stories.count != 0
      @stories = @stories.paginate(:page => params[:page], :per_page => 5)
    end

    if logged_in?
      @user_id = current_user.id
    else
      @user_id = -1
    end
  end

  #KJS: Create a user's blog post
  def create
     if not logged_in?
      flash[:alert] = 'You need to be logged in to post a story!'
      redirect_back_or(root_url)
    else
      @found_community = Membership.find(:all, :conditions => {:user_id => current_user.id})
      unless @found_community.nil? || @found_community.empty?
        # save story
        story = Story.new
        story.kind = Story::Post
        story.description = params[:discuss][:description].to_s
        story.title = params[:discuss][:title].to_s
        # TODO: Story should be associated with a topic.
        # However, right now, topics are highly transient
        # And the topic modeling code isn't flexible enough for me to run it on the user
        # contributed stories.
        story.topic_id = -1
        if params[:discuss][:photo]
          story.image = params[:discuss][:photo]
        end
        story.user_id = current_user.id
        story.source_url = ""
        story.published_at = DateTime.now
        # Give the user posted story an initial kick of popularity
        story.increase_popularity(Story::ScorePost)

        #KJS: from check-boxes
        unselected_ids = Array.new
        selected_ids = Array.new
        if params[:unchecked_ids]
          unselected_ids = params[:unchecked_ids].collect {|id| id.to_i} 
        end

        if params[:community_ids]
          selected_ids = params[:community_ids].collect {|id| id.to_i} 
        end
        if selected_ids.nil? || selected_ids.empty?
          public_community = Community.find(:first, :conditions => "name = 'Public'")
          selected_ids.push(public_community.id)
        end
        if story.save
          flash[:notice] = "Your post '" << story.title << "' was successfully posted!"
          selected_ids.each do |sel_id|
            Annotation.new(:story_id => story.id, :community_id => sel_id).save!
          end
          # create activity
          activity = ActivityItem.create(
            :story_id => story.id,
            :user_id  => current_user.id,
            :topic_id => -1,
            :kind     => ActivityItem::CreatePostType)
          activity.save
          redirect_to('#shared')
          return;
        end

        if story.title == ""
          flash[:error] = "Title of your post cannot be empty!"
        elsif story.description == ""
          flash[:error] = "Content of your post cannot be empty!"
        end

        redirect_back_or(root_url)
      else
        flash[:alert] = 'You should be a member in any community'
        redirect_to(communities_url)
      end
    end
  end

end
