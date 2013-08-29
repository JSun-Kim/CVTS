class Cvote < ActiveRecord::Base
#  attr_accessible :approval, :ballot_id, :user_id

scope :required, where(:approval => nil)
scope :pending, joins(:ballot).where('ballots.over = ?', false)
scope :past, where('approval = ? or approval =?', true, false)

belongs_to :ballot
belongs_to :user

end
