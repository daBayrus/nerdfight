class Quiz < ActiveRecord::Base
  has_many :questions
  has_many :teams
  has_many :scores
  belongs_to :winner, class_name: "Team"

  class << self
    def start
      create(
        questions: Question.unasked,
        teams: Team.all
      )
    end
  end

  def all_questions_asked?
    questions.unasked.size == 0
  end

  def conclude
    decide_winner
  end

  def decide_winner
    winner = team_standings.first
    save
  end

  def score(team, question, points)
    scores.create(team: team, question: question, points: points)
    score_cache[team.id] += points
  end

  def total_score(team)
    score_cache[team.id]
  end

  def score_cache
    unless @score_cache
      @score_cache = {}
      teams.each do |team|
        @score_cache[team.id] = 0
      end
      scores.each do |score|
        @score_cache[score.team.id] += score.points
      end
    end
    @score_cache
  end

  def team_standings
    sorted = score_cache.sort_by { |id, value| value }.reverse
    s = []
    sorted.each do |id, points|
      s << teams.find(id)
    end
    s
  end

end
