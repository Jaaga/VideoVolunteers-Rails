class TrackersController < ApplicationController
  before_filter :is_admin?, :only => [:destroy]

  def index
    if params[:recent]
      @trackers = Tracker.where(updated_at: Date.today-14...Date.today+1).order("updated_at DESC").paginate(page: params[:page], per_page: 40)
      @title = "Recent Trackers"
    elsif !params[:state_name].blank?
      @state = State.find_by(name: params[:state_name])
      @trackers = @state.trackers.order("uid DESC").paginate(page: params[:page], per_page: 40)
      @title = "#{ @state.name }'s Videos"
    elsif !params[:view].blank?
      if [params[:view]].any? { |x| ['edit', 'finalize'].include?(x) }
        @title = 'Editor View'
        if params[:view] == 'edit'
          @trackers = Tracker.where("editor_currently_in_charge = ?", "#{params[:name]}").order("updated_at DESC").paginate(page: params[:page], per_page: 40)
          @title_header = "Cleared For Edit"
        elsif params[:view] == 'finalize'
          @trackers = Tracker.where("editor_currently_in_charge = ? AND finalized_date IS NOT NULL", "#{params[:name]}").order("updated_at DESC").paginate(page: params[:page], per_page: 40)
          @title_header = "Has Been Finalized"
        end
      elsif [params[:view]].any? { |x| ['pitched', 'pending', 'hold'].include?(x) }
        @title = 'State Coordinator View'
        if params[:name] == 'ROI'
          # Get a list of all ROI state IDs and find the trackers based on this list
          @states = State.where(roi: true)
          roi_states = @states.map{ |state| state.id }.to_a
          if params[:view] == 'pitched'
            @trackers = Tracker.where("state_id IN (?) AND story_pitch_date IS NOT NULL", roi_states).order("updated_at DESC").paginate(page: params[:page], per_page: 40)
            @title_header = "Has been Pitched But Has No Footage"
          elsif params[:view] == 'pending'
            @trackers = Tracker.where("state_id IN (?) AND footage_check_date IS NULL AND office_responsible = ?", roi_states, 'State').order("updated_at DESC").paginate(page: params[:page], per_page: 40)
            @title_header = "Raw Footage Has Not Been Reviewed and Footage is in State"
          elsif params[:view] == 'hold'
            @trackers = Tracker.where("state_id IN (?) AND proceed_with_edit_and_payment = ?", roi_states, 'On hold').order("updated_at DESC").paginate(page: params[:page], per_page: 40)
            @title_header = "Edit and Payment is on Hold"
          end
        else
          if params[:view] == 'pitched'
            @trackers = Tracker.where("state_name = ? AND story_pitch_date IS NOT NULL", "#{params[:name]}").order("updated_at DESC").paginate(page: params[:page], per_page: 40)
            @title_header = "Has been Pitched But Has No Footage"
          elsif params[:view] == 'pending'
            @trackers = Tracker.where("state_name = ? AND footage_check_date IS NULL AND office_responsible = ?", "#{params[:name]}", 'State').order("updated_at DESC").paginate(page: params[:page], per_page: 40)
            @title_header = "Raw Footage Has Not Been Reviewed and Footage is in State"
          elsif params[:view] == 'hold'
            @trackers = Tracker.where("state_name = ? AND proceed_with_edit_and_payment = ?", "#{params[:name]}", 'On hold').order("updated_at DESC").paginate(page: params[:page], per_page: 40)
            @title_header = "Edit and Payment is on Hold"
          end
        end
      end
    else
      @trackers = Tracker.all.paginate(page: params[:page], per_page: 40)
      @title = "All Video Forms"
    end

    @columns = Tracker.column_names - ['id', 'tracker_details_id',
                                         'tracker_details_type']
    @default_columns = @columns[0..7]
    @non_default_columns = view_context.checkbox_label(@columns)
  end

  def show
    @tracker = Tracker.find(params[:id])
    @columns = view_context.array_set

    unless @tracker.uid.include?('_impact')
      @columns.except!(:impact_planning, :impact_achieved, :impact_video)
    end

    if @tracker.uid.include?('_impact')
      @columns[:extra] -= ['impact_uid']
    else
      @columns[:extra] -= ['original_uid', 'no_original_uid']
    end

    @sections = @columns.keys
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
    @sections = [:general_info, :impact_planning]
  end

  def create
    @tracker = Tracker.new(tracker_params)

    # Method for dealing with making and linking impact videos
    @is_impact = is_impact?('new')
    if params[:tracker][:is_impact] == false
      if params[:tracker][:footage_recieved] == true 
        @tracker.tracker_type = "Issue"
        @is_issue = true
      else
        @tracker.tracker_type = "Story"
        @is_issue = false
      end
    else
      @tracker.tracker_type = "Impact"
      @is_issue = false
    end
    # This condition exists just in case somebody submits a tracker with an
    # empty 'CC Name'. This way, simple_form will pick up on the model
    # validations.
    unless params[:tracker][:cc_id].blank?
      @cc = Cc.find(params[:tracker][:cc_id])
      @tracker.cc_name = @cc.full_name
      @state = @cc.state
      @tracker.state_name = @state.name
      @tracker.uid = view_context.set_uid(@state.trackers, @cc.state_abb,
                                          @tracker, @is_issue, @is_impact)
      @tracker.assign_attributes(state: @state, cc: @cc)
    end

    if @tracker.save
      @tracker.update_attribute(:updated_by,
              "#{ Date.today }: #{ current_user.email } created this tracker.")
      unless performed? then flash[:success] = "Tracker successfully created." end
      redirect_to @tracker unless performed?
    else
      failed_form_create unless performed?
    end
  end

  def edit
    @tracker = Tracker.find(params[:id])
    @columns = view_context.array_set

    unless @tracker.uid.include?('_impact')
      @columns.except!(:impact_planning, :impact_achieved, :impact_video)
    end

    @state = @tracker.state
    @state_videos = @state.trackers.where("impact_uid IS NULL AND uid NOT
                                          LIKE '%_impact'").map {|x| x.uid}

    @state_videos -= [@tracker.uid]
    unless @tracker.original_uid.blank?
      original = Tracker.find_by(uid: @tracker.original_uid)
      @state_videos += [original.uid]
    end
    @sections = @columns.keys
    @sections -= [:extra]
    @unique = view_context.unique_set
    @context = "edit"
  end

  def update
    @tracker = Tracker.find(params[:id])

    @linked_uid = @tracker.original_uid
    @tracker.assign_attributes(tracker_params)
    @tracker.updated_by = "#{ Date.today }: #{ current_user.email } edited this tracker.\n"

    # Method for dealing with making and linking impact videos
    is_impact?('edit')

    # Method for updating the CC's last impact action date
    update_cc_action_date

    if @tracker.save
      unless performed? then flash[:success] = "Tracker successfully edited." end
      redirect_to @tracker unless performed?
    else
      failed_form_create_edit unless performed?
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
        @tracker.notes = "#{ Date.today }: #{ params[:tracker][:notes] }\n#{ old_notes }"
      end

      @tracker.updated_by = "#{ Date.today }: #{ current_user.email } added a note.\n"

      if @tracker.save
        flash[:success] = "Note successfully added."
        redirect_to @tracker
      else
        flash[:error] = "This form is not complete. Please complete it before
          saving a note."
        redirect_to edit_tracker_path(@tracker)
      end
    end
  end

  def destroy
    @tracker = Tracker.find(params[:id])
    @tracker.destroy
    flash[:success] = "Tracker successfully deleted."
    redirect_to trackers_path(recent: true)
  end

  private


    def tracker_params
      columns = Tracker.column_names - ['id', 'uid', 'created_at',
                                        'updated_at', 'flag', 'flag_notes',
                                        'flag_date', 'note',
                                        'updated_by', 'state_id']
      params.require(:tracker).permit(columns)
    end

    # Method for making sure that impact trackers are currently made.
    def is_impact?(caller)
      # For checking if this tracker is an impact tracker
      if params[:tracker][:is_impact] == "1"
        if params[:tracker][:original_uid].blank? && params[:tracker][:no_original_uid].blank?
          flash.now[:error] = "Need an original_uid or a reason for not having one if
                           this is an impact video"
          is_impact_error(caller)
        elsif !params[:tracker][:original_uid].blank? && !params[:tracker][:no_original_uid].blank?
          flash.now[:error] = "You don't need a reason for not having an original
                               uid if you have selected an original uid."
          is_impact_error(caller)
        elsif caller == 'edit'
          view_context.impact_edit_system(@tracker)
        end
        # This variable will be passed on to the UID setter so that impact UID's
        # can be made. (for @is_impact)
        return true
      elsif params[:tracker][:is_impact] == "0"
        if !params[:tracker][:original_uid].blank? && !params[:tracker][:no_original_uid].blank?
          flash.now[:error] = "The 'is impact' checkbox needs to be checked if it
                               is an impact video."
          caller == 'new' ? failed_form_create : failed_form_create_edit
        elsif !params[:tracker][:original_uid].blank? && params[:tracker][:no_original_uid].blank?
          flash.now[:error] = "The 'is impact' checkbox needs to be checked if it
                               is an impact video."
          caller == 'new' ? failed_form_create : failed_form_create_edit
        elsif params[:tracker][:original_uid].blank? && !params[:tracker][:no_original_uid].blank?
          flash.now[:error] = "The 'is impact' checkbox needs to be checked if it
                               is an impact video."
          caller == 'new' ? failed_form_create : failed_form_create_edit
        elsif caller == 'edit'
          view_context.remove_impact_edit_system(@tracker, @linked_uid)
        end
      end
    end

    # Method for re-rendering the forms page if there is an error.
    def is_impact_error(caller)
      if caller == 'new'
        failed_form_create
      else
        @tracker.is_impact = nil
        failed_form_create_edit
      end
    end

    # Updates a CC's last impact action date if the impact action checkbox in
    # the tracker's form was checked.
    def update_cc_action_date
      if params[:tracker][:cc_impact_action] == '1'
        @tracker.cc.last_impact_action_date = Date.today
      end
    end

    # Method for re-rendering 'new' if an error was found.
    def failed_form_create
      @columns = view_context.array_set
      @unique = view_context.unique_set
      @state = State.find_by(name: params[:tracker][:state_name])
      @state_videos = @state.trackers.where("impact_uid IS NULL AND uid NOT
                                            LIKE '%_impact'").map {|x| x.uid}
      @sections = [:story]
      @context = "new"
      render :new, state_name: params[:tracker][:state_name]
    end

    # Method for re-rendering 'edit' if an error was found.
    def failed_form_create_edit
      @columns = view_context.array_set
      @state = @tracker.state
      @state_videos = @state.trackers.where("impact_uid IS NULL AND uid NOT
                                            LIKE '%_impact'").map {|x| x.uid}

      @state_videos -= [@tracker.uid]
      unless @tracker.original_uid.blank?
        original = Tracker.find_by(uid: @tracker.original_uid)
        @state_videos += [original.uid]
      end
      @sections = @columns.keys
      @sections -= [:extra]
      @unique = view_context.unique_set
      @context = "edit"
      render :edit
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
