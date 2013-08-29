module CommunitiesHelper
	def joined_date(user_id, community_id)
		@membership = Membership.find(:first, :conditions => ["community_id = ? AND user_id = ?", community_id, user_id])
		date = @membership.updated_at
		return date.strftime("%m/%d/%Y")
	end

  def left_date(user_id, community_id)
    @opt_out_ballot = Ballot.find(:first, :conditions => ["content_id = ? AND author_id = ? AND vote_type= ?", @community.id, user_id, "leave_community"])
    @user_cvote = Cvote.find(:first, :conditions => ["ballot_id is ? AND user_id = ? AND approval = ?", @opt_out_ballot.id, user_id, true ])
    date_str = ""
    unless @user_cvote.nil?
      date = @user_cvote.updated_at  
      date_str = date.strftime("%m/%d/%Y")
    end 
    return date_str 
    
  end
	def reject_date(user_id, community_id)
		@ballots_in_community = Ballot.find(:all, :conditions => ["content_id = ?", community_id])
    @user_cvote = Cvote.find(:first, :conditions => ["ballot_id IN (?) AND user_id = ? AND approval = ?", @all_ballots_in_community, user_id, false ])
    	date_str = ""
    	unless @user_cvote.nil?
  			date = @user_cvote.updated_at  
  			date_str = date.strftime("%m/%d/%Y")
  		end	
  		return date_str 
   end
end
