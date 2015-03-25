class TrackersController < ApplicationController

  def index
    @trackers = Tracker.all
    @columns = Tracker.column_names - ['id', 'tracker_details_id',
                                       'tracker_details_type']
  end

  def show
    @tracker = Tracker.find(params[:id])
    @columns = view_context.array_set
    @sections = @columns.keys
    @sections -= [:special, :yesno, :numbers]
  end

  def new
    @tracker = Tracker.new
    @state = State.find_by(name: params[:state_name])
    @columns = view_context.array_set
    @unique = view_context.unique_set
    @context = "new"
  end

  def create
    @tracker = Tracker.new(tracker_params)

    @cc = Cc.find(params[:tracker][:tracker_details_id])
    @tracker.cc_name = @cc.full_name
    @state = @cc.state
    @tracker.state_name = @state.name

    @tracker.uid = view_context.set_uid
    if @tracker.save
      @tracker.update_attribute(:tracker_details, @cc)
      @tracker.update_attribute(:tracker_details, @state)
      flash[:success] = "Tracker successfully created."
      redirect_to @tracker
    else
      @columns = view_context.array_set
      @unique = view_context.unique_set
      @context = "new"
      render :new
    end
  end

  def edit
    @tracker = Tracker.find(params[:id])
    @columns = view_context.array_set
    @sections = @columns.keys
    @sections -= [:extra]
    @unique = view_context.unique_set
    @context = "edit"
  end

  def update
    @tracker = Tracker.find(params[:id])
    @tracker.assign_attributes(tracker_params)
    if @tracker.save
      flash[:success] = "Tracker successfully edited."
      redirect_to @tracker
    else
      @columns = view_context.array_set
      @context = "edit"
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
      columns = Tracker.column_names - ['id', 'uid', 'created_at',
                                        'updated_at', 'flag', 'flag_notes',
                                        'flag_date', 'note',
                                        'updated_by', 'tracker_details_type',
                                        'tracker_details_id']
      params.require(:tracker).permit(columns)
    end
end
