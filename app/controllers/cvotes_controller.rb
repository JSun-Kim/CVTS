class CvotesController < ApplicationController
  # GET /cvotes
  # GET /cvotes.json
  def index
    @cvotes = current_user.cvotes

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  # GET /cvotes/1/edit
  def edit
    @cvote = Cvote.find(params[:id])
  end
 
  # PUT /cvotes/1
  # PUT /cvotes/1.json
 def update
    @cvote = Cvote.find(params[:id])
    response_type = ''
    if params[:vote_yes]
      @cvote.approval = true
      response_type = 'response_yes'

    else
      @cvote.approval = false
      response_type = 'response_no'
    end

    @cvote.save

    if @cvote.update_attributes(params[:cvote])
      if @cvote.approval
        @ballot = @cvote.ballot
        @community = Community.find(@ballot.content_id) #through annotations
        @community.users << User.find(current_user.id)
        @community.save
      end
      Ballot.vote_check(@cvote.ballot)

       # KJS: one loop between ballots and cvotes..to get the response whether the invited user accepts/rejects
      @community_id = params[:community_id_invited]
      @community_invited = Community.find_by_id(@community_id)
      
      @response_ballot = Ballot.new('content_id' => @community_id, 'over' => false,
            'vote_type' => response_type, 'users' => @community_invited.users-[current_user], 'author_id' => current_user.id)
      @response_ballot.save

      respond_to do |format|
        format.html { redirect_to(ballots_path) }
      end
      
    end
  end

  def voteaction
    #from views/ballots/show
    if params[:vote_yes] || params[:vote_no]
      update
      return #KJS: should provide this....avoiding double rendering
    end
    #KJS: Not used for now...(Aug.08.2013) when accepting multiple items in a list with checkboxes, then use this one..
    if params[:submit_yes]
        Cvote.update_all(["approval=?", true], :id => params[:cvote_ids])
        cvote_yes_ids = params[:cvote_ids]
        #update memberships....
        if params[:cvote_ids]
          cvote_yes_ids.each do |yes_id|
            @cvote = Cvote.find(yes_id)
            @ballot = @cvote.ballot
            @community = Community.find(@ballot.content_id) #through annotations
            @community.users << User.find(current_user.id)
            @community.save
          end
        end
    elsif params[:submit_no]
        Cvote.update_all(["approval=?", false], :id => params[:cvote_ids])
    end
    #need to call vote_check for all of the ballots we're voting on
    if params[:cvote_ids]
      cvote_ids = params[:cvote_ids]
      cvote_ids.each do |cvote_id|
        @cvote = Cvote.find(cvote_id)
        Ballot.vote_check(@cvote.ballot)
      end
    end
    redirect_to ballots_path
  end
end
