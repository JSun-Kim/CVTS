class Notification < ActiveRecord::Base
  belongs_to :ballot
  attr_accessible :approved, :finished, :message
end
