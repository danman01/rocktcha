class Song < ActiveRecord::Base

  has_many :rock_sessions
  belongs_to :user

end
