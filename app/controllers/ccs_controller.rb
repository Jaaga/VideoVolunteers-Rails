class CcsController < ApplicationController
  before_filter :is_admin?, :only => [:destroy]

  def index
    @ccs, @alphaParams = Cc.all.order("full_name ASC").alpha_paginate(params[:letter],
                         {:bootstrap3 => true}){|cc| cc.full_name}
    @columns = Cc.column_names - ['id', 'first_name', 'last_name',
                                  'state_name', 'state_id', 'notes']
  end

  def show
    @cc = Cc.find(params[:id])
    @columns = Cc.column_names - ['id', 'full_name', 'state_id']
    # Using select to get rid of the nil values.
    @column_dates = Cc.column_names.select{ |x| x.include?('_date') }.map{ |x| x }
    @columns -= @column_dates
  end

  def new
    @cc = Cc.new
    @columns = Cc.column_names - ['id', 'full_name', 'state_id', 'state_abb']
    # Using select to get rid of the nil values.
    @column_dates = Cc.column_names.select{ |x| x.include?('_date') }.map{ |x| x }
    @columns -= @column_dates
  end

  def create
    unless params[:cc][:state_id].blank?
      @state = State.find(params[:cc][:state_id])
      @cc = @state.ccs.new(cc_params)
      @cc.state_name = @state.name
      @cc.state_abb = @state.state_abb
      if @cc.save
        flash[:success] = "CC successfully created."
        redirect_to @cc
      else
        flash[:error] = "All fields with an * need to be filled."
        @cc = Cc.new
        @columns = Cc.column_names - ['id', 'full_name', 'state_id', 'state_abb']
        # Using select to get rid of the nil values.
        @column_dates = Cc.column_names.select{ |x| x.include?('_date') }.map{ |x| x }
        @columns -= @column_dates
        render :new
      end
    else
      flash[:error] = "Need to choose a state."
      @cc = Cc.new
      @columns = Cc.column_names - ['id', 'full_name', 'state_id', 'state_abb']
      # Using select to get rid of the nil values.
      @column_dates = Cc.column_names.select{ |x| x.include?('_date') }.map{ |x| x }
      @columns -= @column_dates
      render :new
    end
  end

  def edit
    @cc = Cc.find(params[:id])
    @columns = Cc.column_names - ['id', 'full_name', 'state_abb', 'notes', 'state_id']
    column_dates = Cc.column_names.select{ |x| x.include?('_date') }.map{ |x| x }
    @columns -= column_dates
  end

  def update
    @cc = Cc.find(params[:id])
    @cc.assign_attributes(cc_params)
    if @cc.save
      flash[:success] = "CC successfully edited."
      redirect_to @cc
    else
      @cc = Cc.find(params[:id])
      @columns = Cc.column_names - ['id', 'full_name', 'state_abb', 'notes', 'state_id']
      column_dates = Cc.column_names.select{ |x| x.include?('_date') }.map{ |x| x }
      @columns -= column_dates
      render :edit
    end
  end

  def note_form
    @cc = Cc.find(params[:id])
    render 'note'
  end

  def note
    @cc = Cc.find(params[:id])

    if params[:cc][:notes].blank?
      flash[:danger] = "Note was blank and not saved."
      redirect_to @cc
    else
      if @cc.notes.blank?
        @cc.notes = "#{ Date.today }: #{ params[:cc][:notes] }"
      else
        old_notes = @cc.notes
        @cc.notes = "#{ Date.today }: #{ params[:cc][:notes] }\n#{ old_notes }"
      end

      if @cc.save
        flash[:success] = "Note successfully added."
        redirect_to @cc
      else
        render :note
      end
    end
  end

  # def destroy
  #   @cc = Cc.find(params[:id])
  #   @cc.destroy
  #   flash[:success] = "CC successfully deleted."
  #   redirect_to ccs_path
  # end

  private


    def cc_params
      columns = Cc.column_names - ['full_name', 'state_name', 'state_abb']
      params.require(:cc).permit(columns)
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


