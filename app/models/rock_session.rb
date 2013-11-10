class RockSession < ActiveRecord::Base
  belongs_to :song
  belongs_to :received_session
  has_many :received_answers
end
