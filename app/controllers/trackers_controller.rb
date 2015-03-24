class TrackersController < ApplicationController

  def index
    @trackers = Tracker.all
    @columns = Tracker.column_names - ['id']
  end

  def show
    @tracker = Tracker.find(params[:id])
    @columns = view_context.array_set
  end

  def new
    @tracker = Tracker.new
    @columns = array_set
    @context = "new"
  end

  def create
    @tracker = Tracker.new(tracker_params)
    @tracker.uid = view_context.set_uid
    if @tracker.save
      flash[:success] = "Tracker successfully created."
      redirect_to @tracker
    else
      render :new
    end
  end

  def edit
    @tracker = Tracker.find(params[:id])
    @columns = view_context.array_set
    @context = "edit"
  end

  def update
    @tracker = Tracker.find(params[:id])
    @tracker.assign_attributes(tracker_params)
    if @tracker.save
      flash[:success] = "Tracker successfully edited."
      redirect_to @tracker
    else
      render :edit
    end
  end

  def destroy
    @tracker = Tracker.find(params[:id])
    @tracker.destroy
    flash[:success] = "Tracker successfully deleted."
    redirect_to trackers_path
  end

  private


    def tracker_params
      columns = Tracker.column_names - ['id', 'uid', 'state_id', 'cc_id',
                                        'created_at', 'updated_at', 'flag',
                                        'flag_notes', 'flag_date', 'note',
                                        'updated_by']
      params.require(:tracker).permit(columns)
    end
end
