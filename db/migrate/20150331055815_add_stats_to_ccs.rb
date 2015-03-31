class AddStatsToCcs < ActiveRecord::Migration
  def change
    add_column :ccs, :last_pitched_story_idea_date, :date
    add_column :ccs, :last_impact_achieved_date, :date
    add_column :ccs, :last_issue_video_made_date, :date
    add_column :ccs, :last_issue_video_sent_date, :date
    add_column :ccs, :last_impact_video_made_date, :date
    add_column :ccs, :last_impact_action_date, :date

    add_column :ccs, :is_inactive, :boolean
  end
end
