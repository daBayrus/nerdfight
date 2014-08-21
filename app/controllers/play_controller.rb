class PlayController < ApplicationController
  skip_before_action :check_if_done
  before_action :quiz, only: [:start, :next]

  def index
  end

  def start
    if @quiz.all_questions_asked?
      @quiz.conclude
    end
  end

  def next
    if @quiz
      question = @quiz.questions.find(params[:question_id])
      question.asked = true
      question.save
      corrects = params[:correct] || {}
      @quiz.teams.each do |team|
        correct = corrects[team.id.to_s]
        if correct
          @quiz.score(team, question, question.points)
        else
          @quiz.score(team, question, 0)
        end
      end
    end
    redirect_to :start_play_index
  end

private

  def quiz
    if session[:quiz_id]
      @quiz = Quiz.find session[:quiz_id]
    else
      @quiz = Quiz.start
      session[:quiz_id] = @quiz.id
    end
    @quiz
  end

end
