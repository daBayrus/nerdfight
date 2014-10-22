class PlayController < ApplicationController
  before_action :set_event, only: [ :start, :next, :quiz, :rankings, :buzz, :answers, :winner ]
  before_action :set_team, only: [ :quiz, :buzz, :answers ]
  before_action :set_question, only: [ :start, :next, :answers ]
  before_action :set_standings, only: [ :start, :quiz, :rankings, :winner ]
  skip_before_action :check_if_done

  def index
  end

  def start
    question = { id: @question.id, content: @question.content, points: @question.points, asked: @asked }
    PrivatePub.publish_to "/questions/active", question
  end

  def next
    if @event
      @question.asked = true
      @question.save
      delete_question_session

      corrects = params[:correct] || {}
      @event.teams.each do |team|
        correct = corrects[team.id.to_s]
        points = correct ? @question.points : 0

        score = @question.scores.find_by_team_id(team.id)
        if score
          score.points = points
          score.save
        end
      end
    end

    redirect_to :start_play_index
  end

  def quiz
    unless @event.all_questions_asked?
      @question = Question.new({ content: '', points: 0, asked: 0 })
      @number = 0
    else
      redirect_to :winner_play_index
    end
  end

  def buzz
    score = Score.new event_id: @event.id, team_id: @team.id, answer: params[:answer]

    @question = Question.find params[:question_id]
    @question.scores << score
  end

  def answers
    @teams = @event.teams
    @answers = @question.scores
  end

  def rankings
  end

  def winner
  end

  private

  def set_event
    if session[:event_id]
      @event = Event.find session[:event_id]
    else
      @event = Event.last
      session[:event_id] = @event.id
    end

    @event
  end

  def set_team
    if session[:team_id]
      @team = @event.teams.find session[:team_id]
    else
      redirect_to new_team_path, alert: 'Only registered teams are allowed to join. Kindly register.'
    end
  end

  def set_question
    question_id = session[:question_id] || params[:question_id]
    if question_id
      @question = @event.questions.find question_id
    else
      unless @event.all_questions_asked?
        @question = @event.questions.unasked.shuffle.first
        session[:question_id] = @question.id
      else
        redirect_to :winner_play_index
      end
    end
    @asked = @event.questions.asked.size + 1
  end

  def set_standings
    standings = {}
    @rankings = {}

    @event.teams.each do |t|
      standings[t.id] = 0
    end

    @event.questions.asked.each do |q|
      q.scores.each do |s|
        standings[s.team_id] += s.points.nil? ? 0 : s.points
      end
    end

    standings = standings.sort_by { |id, value| value }.reverse
    standings.each do |id, points|
      team = @event.teams.find id
      @rankings[team.name] = points
    end

    @rankings
  end

  def delete_question_session
    session.delete(:question_id)
  end
end
