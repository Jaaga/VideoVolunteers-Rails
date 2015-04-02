class StatesController < ApplicationController
  before_filter :is_admin?, :only => [:destroy]

  def index
    @states = State.all.paginate(page: params[:page], per_page: 40)
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

    def is_admin?
      if current_user.try(:admin?)
        true
      else
        flash[:error] = "Need to be an admin for this."
        redirect_to root_path
      end
    end
end
