class StatesController < ApplicationController

  def index
    @states = State.all
    @columns = State.column_names - ['id']
  end

  def show
    @state = State.find(params[:id])
    @columns = State.column_names - ['id']
  end

  def new
    @state = State.new
  end

  def create
    @state = State.create(state_params)
    redirect_to @state
  end

  def edit
    @state = State.find(params[:id])
  end

  def update
    @state = State.find(params[:id])
    @state.update_attributes(state_params)
    redirect_to @state
  end

  def destroy
    @state = State.find(params[:id])
    @state.destroy
    redirect_to states_path
  end

  private


    def state_params
      params.require(:state).permit(:state, :state_abb, :district)
    end
end
