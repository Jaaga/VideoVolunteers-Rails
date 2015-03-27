class CcsController < ApplicationController
  def index
    @ccs, @alphaParams = Cc.all.order("full_name ASC").alpha_paginate(params[:letter], {:bootstrap3 => true}){|cc| cc.full_name}
    @columns = Cc.column_names - ['id', 'first_name', 'last_name',
                                  'state_name', 'state_id', 'notes']
  end

  def show
    @cc = Cc.find(params[:id])
    @columns = Cc.column_names - ['id', 'full_name', 'state_id']
  end

  def new
    @cc = Cc.new
  end

  def create
    @state = State.find(params[:cc][:state_id])
    @cc = @state.ccs.new(cc_params)
    @cc.state_name = @state.name
    @cc.state_abb = @state.state_abb
    if @cc.save
      flash[:success] = "CC successfully created."
      redirect_to @cc
    else
      render :new
    end
  end

  def edit
    @cc = Cc.find(params[:id])
  end

  def update
    @state = State.find(params[:cc][:state_id])
    @cc = Cc.find(params[:id])
    @cc.assign_attributes(cc_params)
    @cc.state_name = @state.name
    @cc.state_abb = @state.state_abb
    if @cc.save
      flash[:success] = "CC successfully edited."
      redirect_to @cc
    else
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

  def destroy
    @cc = Cc.find(params[:id])
    @cc.destroy
    flash[:success] = "CC successfully deleted."
    redirect_to ccs_path
  end

  private


    def cc_params
      params.require(:cc).permit(:first_name, :last_name, :district, :phone, :mentor, :state_id)
    end
end
