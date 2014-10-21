class PlayController < ApplicationController
  before_action :set_event, only: [ :start, :next, :buzz, :answers ]
  before_action :set_team, only: [ :quiz, :buzz, :answers ]
  before_action :set_question, only: [ :start, :next, :answers ]

  skip_before_action :check_if_done

  def index
  end

  def start
    question = { id: @question.id, content: @question.content, points: @question.points, asked: @asked }
    PrivatePub.publish_to "/questions/active", question

    if @event.all_questions_asked?
      @event.conclude
    end
  end

  def next
    if @event
      @question.asked = true
      @question.save
      session[:question_id] = nil

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
    @question = Question.new({ content: '', points: 0, asked: 0 })
    @number = 0
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

  private

  # def safe_params
  #   params.permit :answer
  # end

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
      @team = Team.find session[:team_id]
    else
      redirect_to new_team_path, alert: 'Only registered teams are allowed to join. Kindly register.'
    end
  end

  def set_question
    if session[:question_id]
      @question = Question.find session[:question_id]
    else
      @question = @event.questions.unasked.shuffle.first
      session[:question_id] = @question.id
    end
    @asked = @event.questions.asked.size + 1
  end
end
