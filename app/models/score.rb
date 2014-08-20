class Score < ActiveRecord::Base
  belongs_to :team
  belongs_to :question
  belongs_to :quiz
end
