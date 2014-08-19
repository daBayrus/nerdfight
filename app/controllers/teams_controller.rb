class TeamsController < ApplicationController
  before_action :check_steps, only: [ :new, :create ]
  skip_before_action :check_if_done, only: [ :show ]

  def show
    @team = Team.find params[:id]
  end

  def new
    @team = Team.new
    @nerds = Nerd.new

    session[:step] = 1 if session[:step].nil?
  end

  def create
    @team = Team.new safe_params
    @team.users = User.find safe_nerds_params[:nerds][:user_id].reject &:blank?

    if @team.save
      session[:team_id] = @team.id
      redirect_to new_team_question_path(@team)
    else
      render action: "new"
    end
  end

  private

  def safe_params
    params.require(:team).permit :name
  end

  def safe_nerds_params
    params.require(:team).permit nerds: [user_id: []]
  end

  def check_steps
    redirect_to new_team_question_path(session[:team_id]) unless session[:team_id].nil?
  end
end
