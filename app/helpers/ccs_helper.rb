module CcsHelper

  # Used to capitalize each segment of names and other words along with column
  # names. If the column name won't do for display, a custom one is given in the
  # cc_label method.
  def cc_name_modifier(x)
    !cc_label(x).nil? ? cc_label(x) : x.split('_').map(&:capitalize).join(' ')
  end

  # Gives custom labels to the column names in the labels hash.
  def cc_label(x)
    labels =  { 'last_pitched_story_idea_date' => 'Date of last pitched story idea',
                'last_impact_achieved_date' => 'Date of last impact achieved',
                'last_issue_video_made_date' => 'Date of last issue video made',
                'last_issue_video_sent_date' => 'Date of last issue video sent',
                'last_impact_video_made_date' => 'Date of last impact video made',
                'last_impact_action_date' => 'Date of last impact action' }

    !labels[x].nil? ? labels[x] : nil
  end

  def cc_value_capitalization(x)
    x.split.map(&:capitalize).join(' ')
  end
end
