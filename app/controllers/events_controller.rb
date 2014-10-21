class EventsController < ApplicationController
  def index
  end

  def new
    @version = Event.last.nil? ? 1 : Event.last.id + 1
    @version = RomanNumerals.to_roman @version

    @event = Event.new
  end

  def create
    @event = Event.new safe_params

    if @event.save
      redirect_to new_team_path, alert: 'Event ' + @event.name + ' created.'
    else
      render action: "new"
    end
  end

  private

  def safe_params
    params.require(:event).permit :name, :duration
  end
end
