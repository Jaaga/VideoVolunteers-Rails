class TrackersController < ApplicationController
  before_filter :is_admin?, :only => [:destroy]

  def index
    if params[:recent]
      if params[:state]
        @trackers = Tracker.where(updated_at: Date.today-14...Date.today+1, state_name: params[:state]).order("updated_at DESC").paginate(page: params[:page], per_page: 40)
      else
        @trackers = Tracker.where(updated_at: Date.today-14...Date.today+1).order("updated_at DESC").paginate(page: params[:page], per_page: 40)
      end
      @title = "Recent Trackers"
    elsif !params[:state_name].blank?
      @trackers = State.find_by(name: params[:state_name]).trackers.order("uid DESC").paginate(page: params[:page], per_page: 40)
      @title = "#{params[:state_name]}'s Videos"
    elsif !params[:view].blank?
      if [params[:view]].any? { |x| ['edit', 'finalize'].include?(x) }
        @title = 'Editor View'
        @trackers = Tracker.show_to_editor(params[:view], params[:name]).paginate(page: params[:page], per_page: 40)
        titles = {edit: "Cleared For Edit", finalize: "Has Been Finalized"}
        @title_header = titles[:"#{params[:view]}"] 
      elsif [params[:view]].any? { |x| view_context.find_collection('production_status').map{|y| y[0]}.include?(x) }
        @title = params[:name]+' Coordinator View'
        @title_header = params[:view]
        @trackers = Tracker.where(state_name: params[:name], production_status: params[:view]).paginate(page: params[:page], per_page: 40)
      end
    else
      @trackers = Tracker.all.paginate(page: params[:page], per_page: 40)
      @title = "All Video Forms"
    end
    @columns = Tracker.column_names - ['id', 'tracker_details_id',
                                         'tracker_details_type', 'subcategory', 'shoot_plan', 'footage_rating', 'story_type']
    @default_columns = @columns[0..6]
    @non_default_columns = view_context.checkbox_label(@columns)
  end


  def show
    @tracker = Tracker.find(params[:id])
    @columns = view_context.show_array_set

    unless @tracker.uid.include?('_impact')
      @columns.except!(:impact_achieved, :impact_video, :screening)
    end

    if @tracker.uid.include?('_impact')
      @columns[:extra] -= ['impact_uid']
    else
      @columns[:extra] -= ['original_uid', 'no_original_uid']
    end
    @sections = @columns.keys
  end

  def new
    if params[:tracker_type] && params[:tracker_id]
      @track = Tracker.find(params[:tracker_id])
      @tracker = Tracker.new
      @track.attributes.except("id","created_at","updated_at").each do |key, value|
        @tracker[key] = value
      end
      @tracker.is_impact = true
      @state = @tracker.state
      @tracker.tracker_type = "Impact"
      @tracker.original_uid = @tracker.uid
      @columns = view_context.array_set
      @unique = view_context.unique_set
      @context = "new"
      @sections = [:general_info, :impact_achieved, :impact_video, :screening, :final]
    else
      @tracker = Tracker.new
      @state = State.find_by(name: params[:state_name])
      # For dropdown of issue videos that have no impact videos linked to them.
      @state_videos = @state.trackers.where("impact_uid IS NULL AND uid NOT
                                            LIKE '%_impact'").map {|x| x.uid}
      @columns = view_context.array_set
      @unique = view_context.unique_set
      @context = "new"
      @sections = [:general_info, :footage_check, :impact_planning]
    end
  end

  def create
    @tracker = Tracker.new(tracker_params)

    # Method for dealing with making and linking impact videos
    @is_impact = is_impact?('new')
    # if params[:tracker][:is_impact] == false
    #   if params[:tracker][:footage_recieved] == true 
    #     @tracker.tracker_type = "Issue"
    #     @is_issue = true
    #   else
    #     @tracker.tracker_type = "Story"
    #     @is_issue = false
    #   end
    # else
    #   @tracker.tracker_type = "Impact"
    #   @is_issue = false
    # end
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

    @state = @tracker.state
    # @state_videos = @state.trackers.where("impact_uid IS NULL AND uid NOT
    #                                       LIKE '%_impact'").map {|x| x.uid}
    # @state_videos -= [@tracker.uid]
    # unless @tracker.original_uid.blank?
    #   original = Tracker.find_by(uid: @tracker.original_uid)
    #   @state_videos += [original.uid]
    # end
    if current_user.division == "State Coordinator"
      @sections = [:general_info, :impact_planning, :footage_check, :edit, :rought_cut_sent_to_goa]
    else
      @sections = [:general_info, :impact_planning, :footage_check, :edit, :rought_cut_sent_to_goa, 
                  :rough_cut_recieved_in_goa, :rough_cut_edit, :rough_cut_review, :final]
    end

    if @tracker.uid.include?('_impact')
      @sections += [:impact_achieved, :impact_video]
      @sections -= [:impact_planning]
    end
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


  def by_month
    if params[:state]
      @trackers = Tracker.where("strftime('%m',created_at) = ? AND state_name = ?", Time.new.strftime('%m'), params[:state])
    else
      @trackers = Tracker.where("strftime('%m',created_at) = ?", Time.new.strftime('%m'))
    end
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
