class BallotsController < ApplicationController
  # GET /ballots
  # GET /ballots.json
  def index
    @filter = params[:filter]

    if @filter.nil?
      @filter = 'pending'
    end

    if @filter == 'pending'
      #current_user.cvotes returns a relation which can be extended with the 'pending' scope and 'required' scope to filter only votes that are still pending and need the current_user to vote
      @cvotes = current_user.cvotes.pending.required.sort!{|a,b| b.created_at <=> a.created_at}
    elsif @filter == 'past'
      #current_user.cvotes returns a relation which can be extended with the 'past' scope to filter only votes that have been votes on
      @cvotes = current_user.cvotes.past.sort!{|a,b| b.created_at <=> a.created_at}
    else
      @cvotes = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ballots }
    end
  end

  # GET /ballots/1
  # GET /ballots/1.json
  def show
     @ballot = Ballot.find(params[:id])

    if @ballot.vote_type == "exception"
      @email = Email.find(@ballot.content_id)
    end

    community_members = []
    community_user_ids = []
    @community_memberships = Membership.find(:all, :conditions => ["community_id = ?", @ballot.content_id])
    @community_user_ids = @community_memberships.map {|c| c.user_id}
    @community_members = User.find(:all, :conditions => ["id IN (?)",@community_user_ids])

    @cvotes = []
    cvotes_user_ids = []
    @pending_members = [] 
    @accept_members = []
    @reject_members = []
    
    @all_ballots_in_community = Ballot.find(:all, :conditions => ["content_id = ?", @ballot.content_id])
    @cvotes = Cvote.find(:all, :conditions => ["ballot_id IN (?)", @all_ballots_in_community ])
    @cvotes_user_ids = @cvotes.map {|c| c.user_id if c.approval == nil}.compact - @community_user_ids
    @pending_members = User.find(:all, :conditions => ["id IN (?)", @cvotes_user_ids])
    @cvotes_user_ids = @cvotes.map {|c| c.user_id if c.approval == false}.compact - @community_user_ids
    @reject_members = User.find(:all, :conditions => ["id IN (?)", @cvotes_user_ids])

    #give me the vote associated with this ballot (the current_user's vote)
    @myvote = @ballot.cvotes.map{|x| x if x.user_id == current_user.id}.compact[0]

    #KJS: if the member added or left is not yourself, then the message is automatrically approved when you see the message
    @cvote = Cvote.find(@myvote.id)
    if @ballot.member_id != current_user.id
     # if @ballot.myballots_type == "Community"
        if @ballot.vote_type == "add_community_member" or @ballot.vote_type == "leave_community" or @ballot.vote_type == "response_yes" or  @ballot.vote_type == "response_no" #KJS: "response_yes/no" --> cvote creates a new ballot for confirmation of the invited user
          @cvote.approval = true
          @cvote.save
          if @cvote.update_attributes(params[:cvote])
            Ballot.vote_check(@cvote.ballot)
          end
        end
      #end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ballot }
    end
  end

  # GET /ballots/new
  # GET /ballots/new.json
  def new
    @ballot = Ballot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ballot }
    end
  end

  # GET /ballots/1/edit
  def edit
    @ballot = Ballot.find(params[:id])
  end

  # POST /ballots
  # POST /ballots.json
  def create
    @ballot = Ballot.new(params[:ballot])

    respond_to do |format|
      if @ballot.save
        format.html { redirect_to @ballot, notice: 'Ballot was successfully created.' }
        format.json { render json: @ballot, status: :created, location: @ballot }
      else
        format.html { render action: "new" }
        format.json { render json: @ballot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ballots/1
  # PUT /ballots/1.json
  def update
    @ballot = Ballot.find(params[:id])

    respond_to do |format|
      if @ballot.update_attributes(params[:ballot])
        format.html { redirect_to @ballot, notice: 'Ballot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ballot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ballots/1
  # DELETE /ballots/1.json
  def destroy
    @ballot = Ballot.find(params[:id])
    @ballot.destroy

    respond_to do |format|
      format.html { redirect_to ballots_url }
      format.json { head :no_content }
    end
  end
end
