class Score < ActiveRecord::Base
  belongs_to :team
  belongs_to :question
  belongs_to :event
  belongs_to :quiz
end
