class UsersController < ApplicationController
  before_filter :is_admin?

  def index
    if params[:approved] == 'false'
      @title = 'Unverified Users'
      @users = User.where(approved: false).paginate(page: params[:page], per_page: 40)
    else
      @title = 'All Users'
      @users = User.all.paginate(page: params[:page], per_page: 40)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params)
    if @user.save
      flash[:success] = "User successfully edited."
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    unless @user.email == current_user.email
      @user.destroy
      flash[:success] = "User successfully deleted."
      redirect_to users_path
    else
      flash[:error] = "Cannot delete self."
      redirect_to @user
    end
  end

  private


    def user_params
      params.require(:user).permit(:division, :admin, :approved)
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
