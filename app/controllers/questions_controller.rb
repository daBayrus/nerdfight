class QuestionsController < ApplicationController
  before_action :set_team

  def new
    @question = Question.new
    session[:step] = 2
  end

  def create
    questions = safe_params
    questions.each do |q|
      @team.questions.new q.second
    end

    if @team.save
      session[:done] = true
      redirect_to team_path(@team)
    end
  end

  private

  def set_team
    @team = Team.find params[:team_id]
  end

  def safe_params
    q_fields = [ :content, :answer, :points ]
    params.require(:question).permit one: q_fields, two: q_fields, five: q_fields
  end
end
