class Event < ActiveRecord::Base
  has_many :teams
  has_many :questions
  has_many :scores

  def all_questions_asked?
    questions.unasked.size == 0
  end
end
