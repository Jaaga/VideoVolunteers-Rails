class TrackersController < ApplicationController

  def index
    @trackers = Tracker.all.order("uid DESC")
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

    if params[:tracker][:is_impact] != "0"
      if params[:tracker][:original_uid].blank? && params[:tracker][:no_original_uid].blank?
        flash.now[:error] = "Need an original_uid or a reason for not having one if
                         this is an impact video"
        failed_form_create
        return
      end
      # This variable will be passed on to the UID setter so that impact UID's
      # can be made.
      @is_impact = true
    end

    unless params[:tracker][:cc_name].blank?
      @cc = Cc.find(params[:tracker][:cc_name])
      @tracker.cc_name = @cc.full_name
      @state = @cc.state
      @tracker.state_name = @state.name
      @tracker.uid = view_context.set_uid(@state.trackers, @cc.state_abb, @tracker, @is_impact)
    end

    if @tracker.save
      @tracker.update_attribute(:tracker_details, @cc)
      @tracker.update_attribute(:tracker_details, @state)
      flash[:success] = "Tracker successfully created."
      redirect_to @tracker
    else
      failed_form_create
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

    def failed_form_create
      @columns = view_context.array_set
      @unique = view_context.unique_set
      @state = State.find_by(name: params[:tracker][:state_name])
      @context = "new"
      render :new, state_name: params[:tracker][:state_name]
    end
end
