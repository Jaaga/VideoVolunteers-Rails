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
    @state = State.new(state_params)
    if @state.save
      flash[:success] = "State successfully created."
      redirect_to @state
    else
      render :new
    end
  end

  def edit
    @state = State.find(params[:id])
  end

  def update
    @state = State.find(params[:id])
    @state.assign_attributes(state_params)
    if @state.save
      flash[:success] = "State successfully edited."
      redirect_to @state
    else
      render :edit
    end
  end

  def destroy
    @state = State.find(params[:id])
    @state.destroy
    flash[:success] = "State successfully deleted."
    redirect_to states_path
  end

  private


    def state_params
      params.require(:state).permit(:name, :state_abb)
    end
end
