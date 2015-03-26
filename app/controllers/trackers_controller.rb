class TrackersController < ApplicationController

  def index
    if params[:recent]
      @trackers = Tracker.where(updated_at: Date.today-14...Date.today+1).order("updated_at DESC").paginate(page: params[:page], per_page: 40)
      @title = "Recent Trackers"
    elsif !params[:state_name].blank?
      @state = State.find_by(name: params[:state_name])
      @trackers = @state.trackers.order("uid DESC").paginate(page: params[:page], per_page: 40)
      @title = "#{ @state.name }'s Trackers"
    elsif !params[:view].blank?
      if [params[:view]].any? { |x| ['edit', 'finalize'].include?(x) }
        @title = 'Editor View'
        if params[:view] == 'edit'
          @trackers = Tracker.where("editor_currently_in_charge = ? AND cleared_for_edit = ?", "#{params[:name]}", 'yes').order("updated_at DESC").paginate(page: params[:page], per_page: 40)
          @title_header = "Cleared For Edit"
        elsif params[:view] == 'finalize'
          @trackers = Tracker.where("editor_currently_in_charge = ? AND finalized_date IS NOT NULL", "#{params[:name]}").order("updated_at DESC").paginate(page: params[:page], per_page: 40)
          @title_header = "Has Been Finalized"
        end
      elsif [params[:view]].any? { |x| ['pitched', 'pending', 'hold'].include?(x) }
        @title = 'State Coordinator View'
        if params[:view] == 'pitched'
          @trackers = Tracker.where("state_name = ? AND story_pitch_date IS NOT NULL AND backup_received_date IS NULL", "#{params[:name]}").order("updated_at DESC").paginate(page: params[:page], per_page: 40)
          @title_header = "Has been Pitched But Has No Footage"
        elsif params[:view] == 'pending'
          @trackers = Tracker.where("state_name = ? AND raw_footage_review_date IS NULL AND footage_location = ?", "#{params[:name]}", 'State').order("updated_at DESC").paginate(page: params[:page], per_page: 40)
          @title_header = "Raw Footage Has Not Been Reviewed and Footage is in State"
        elsif params[:view] == 'hold'
          @trackers = Tracker.where("state_name = ? AND proceed_with_edit_and_payment = ?", "#{params[:name]}", 'On hold').order("updated_at DESC").paginate(page: params[:page], per_page: 40)
          @title_header = "Edit and Payment is on Hold"
        end
      end
    else
      @trackers = Tracker.all.paginate(page: params[:page], per_page: 40)
      @title = "All Trackers"
    end

    @columns = Tracker.column_names - ['id', 'tracker_details_id',
                                         'tracker_details_type']
    @default_columns = @columns[0..7]
    @non_default_columns = view_context.checkbox_label(@columns)
  end

  def show
    @tracker = Tracker.find(params[:id])
    @columns = view_context.array_set

    if @tracker.uid.include?('_impact') && !@tracker.original_uid.blank?
      @columns.except!(:impact_planning, :impact_achieved, :impact_video)
    end

    if @tracker.uid.include?('_impact')
      @columns[:extra] -= ['impact_uid']
    else
      @columns[:extra] -= ['original_uid', 'no_original_uid']
    end

    @sections = @columns.keys
    @sections -= [:special, :yesno, :numbers]
  end

  def new
    @tracker = Tracker.new
    @state = State.find_by(name: params[:state_name])
    # For dropdown of issue videos that have no impact videos linked to them.
    @state_videos = @state.trackers.where("impact_uid IS NULL AND uid NOT
                                          LIKE '%_impact'").map {|x| x.uid}
    @columns = view_context.array_set
    @unique = view_context.unique_set
    @context = "new"
  end

  def create
    @tracker = Tracker.new(tracker_params)

    # For checking if this tracker is an impact tracker
    if params[:tracker][:is_impact] == "1"
      if params[:tracker][:original_uid].blank? && params[:tracker][:no_original_uid].blank?
        flash.now[:error] = "Need an original_uid or a reason for not having one if
                         this is an impact video"
        failed_form_create
        return
      elsif !params[:tracker][:original_uid].blank? && !params[:tracker][:no_original_uid].blank?
        flash.now[:error] = "You don't need a reason for not having an original
                             uid if you have selected an original uid."
        failed_form_create
        return
      end
      # This variable will be passed on to the UID setter so that impact UID's
      # can be made.
      @is_impact = true
    else
      unless params[:tracker][:original_uid].blank? && params[:tracker][:no_original_uid].blank?
        flash.now[:error] = "The 'is impact' checkbox needs to be checked if it
                             is an impact video."
        failed_form_create
        return
      end
    end

    # This condition exists just in case somebody submits a tracker with an
    # empty 'CC Name'. This way, simple_form will pick up on the model
    # validations.
    unless params[:tracker][:cc_name].blank?
      @cc = Cc.find(params[:tracker][:cc_name])
      @tracker.cc_name = @cc.full_name
      @state = @cc.state
      @tracker.state_name = @state.name
      @tracker.uid = view_context.set_uid(@state.trackers, @cc.state_abb,
                                          @tracker, @is_impact)
    end

    if @tracker.save
      @tracker.update_attribute(:updated_by,
                              "#{ Date.today }: Someone created this tracker.")
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

    if @tracker.uid.include?('_impact') && !@tracker.original_uid.blank?
      @columns.except!(:impact_planning, :impact_achieved, :impact_video)
    end
  end

  def update
    @tracker = Tracker.find(params[:id])
    @tracker.assign_attributes(tracker_params)
    @tracker.updated_by.prepend("#{ Date.today }: this tracker was edited.\n")

    if @tracker.save
      flash[:success] = "Tracker successfully edited."
      redirect_to @tracker
    else
      @columns = view_context.array_set
      @sections = @columns.keys
      @sections -= [:extra]
      @unique = view_context.unique_set
      @context = "edit"
      render :edit
    end
  end

  # Notes exists to add text to the 'notes' column.
  def note_form
    @tracker = Tracker.find(params[:id])
    render 'note'
  end

  def note
    @tracker = Tracker.find(params[:id])

    if params[:tracker][:notes].blank?
      flash[:danger] = "Note was blank and not saved."
      redirect_to @tracker
    else
      if @tracker.notes.blank?
        @tracker.notes = "#{ Date.today }: #{ params[:tracker][:notes] }"
      else
        old_notes = @tracker.notes
        @tracker.notes = "#{ Date.today }:
                          #{ params[:tracker][:notes] }\n#{ old_notes }"
      end

      @tracker.updated_by.prepend("#{ Date.today }: Someone added a note.\n")

      if @tracker.save
        flash[:success] = "Note successfully added."
        redirect_to @tracker
      else
        render :note
      end
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
