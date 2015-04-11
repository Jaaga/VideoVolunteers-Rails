module CollectionsHelper

  def find_collection(column)
    if column == 'iu_theme' || column == 'subcategory'
      return themes_collection
    elsif column == 'story_type'
      return types_collection
    elsif column == 'campaign'
      return campaigns_collection
    elsif column == 'screened_on'
      return screens_collection
    elsif column == 'editor_currently_in_charge'
      return editors_collection
    elsif column == 'impact_verified_by' || column == 'impact_video_approved_by'
      return staff_collection
    elsif column == 'project'
      return [['None', :None], ['Oak', :Oak], ['PACS', :PACS]]
    elsif column == 'edit_status'
      return edit_status_collection
    elsif column == 'office_responsible'
      return [['State', :State], ['HQ', :HQ]]
    elsif column == 'proceed_with_edit_and_payment'
      return [['Cleared', :Cleared], ['On hold', :'On hold']]
    elsif column == 'payment_status'
      return [['Approved', :Approved], ['Paid', :Paid], ['Hold', :Hold]]
    elsif column == 'subtitle_info'
      return subtitle_collection
    elsif column == 'editor_changes_needed'
      return editor_changes_collection
    elsif column == 'translation_info'
      return translation_collection
    elsif column == 'impact_video_status'
      return impact_status_collection
    end
  end

  def ratings_collection
    [['1 - Poor (CC must reshoot)', :'1 - Poor (CC must reshoot)'],
     ['2 - Mediocre', :'2 - Mediocre'],
     ['3 - Very Good', :'3 - Very Good'],
     ["4 - One of the Best Videos I've Seen",
     :"4 - One of the Best Videos I've Seen"]]
  end

  def themes_collection
    [["Arts and Culture", :"Arts and Culture"],
     ["Caste", :Caste], ["Gender", :Gender],
     ["Religion and Identity", :"Religion and Identity"],
     ["Indigenous People", :"Indigenous People"],
     ["Governance and Accountability", :"Governance and Accountability"],
     ["Corruption", :Corruption], ["Health", :Health],
     ["Education", :Education], ["Livelihoods", :Livelihoods],
     ["Food and Social Security", :"Food and Social Security"],
     ["Water", :Water], ["Information Technology", :"Information Technology"],
     ["Environment", :Environment],
     ["Roads and Public Works", :"Roads and Public Works"],
     ["Power and Energy", :"Power and Energy"], ["Mining", :Mining],
     ["State Repression", :"State Repression"],
     ["Forced Evictions", :"Forced Evictions"], ["Sanitation", :Sanitation],
     ["Natural Disaster", :"Natural Disaster"]].sort
  end

  def types_collection
    [["Entitlement Violation", :"Entitlement Violation"],
     ["Inspirational Videos", :"Inspirational Videos"],
     ["Human Rights Violation", :"Human Rights Violation"],
     ["CC Profile", :"CC Profile"], ["Community Profile", :"Community Profile"],
     ["Mini-doc", :"Mini-doc"], ["Success", :Success]].sort
  end

  def campaigns_collection
    [["None", :None], ["ARTICLE17 (Anti-Untouchability)", :"ARTICLE17 (Anti-Untouchability)"],
     ["RTE-Pass ya Fail", :"RTE-Pass ya Fail"],
     ["Forced Evictions", :"Forced Evictions"],
     ["Maternal Health", :"Maternal Health"],
     ["Violence Against Women", :"Violence Against Women"]]
  end

  def screens_collection
    [["tablet", :tablet], ["video camera", :"video camera"],
     ["laptop", :laptop], ["DVD player", :"DVD player"],
     ["projector", :projector]].sort
  end

  def editors_collection
    [["Sanjay Parmar", :"Sanjay Parmar"],
     ["Dheeraj Sharma", :"Dheeraj Sharma"],
     ["Guruprasad Pednekar", :"Guruprasad Pednekar"],
     ["Kamar Sayeed", :"Kamar Sayeed"], ["Shobha Ajay", :"Shobha Ajay"],
     ["Debaranjan Sarangi", :"Debaranjan Sarangi"],
     ["Kanhaiya Maurya", :"Kanhaiya Maurya"],
     ["Zuhaib Ashraf", :"Zuhaib Ashraf"], ["Deepak Bara", :"Deepak Bara"],
     ["Raviraj Naik", :"Raviraj Naik"], ["Ashok", :Ashok]].sort
  end

  def staff_collection
    [["Stalin K.", :"Stalin K."], ["Jessica Mayberry", :"Jessica Mayberry"],
     ["Manish Kumar", :"Manish Kumar"], ["Anand Hembrom", :"Anand Hembrom"],
     ["Sarita Biswal", :"Sarita Biswal"], ["Radhika", :Radhika],
     ["Amrita Anand", :"Amrita Anand"],
     ["Kayonaaz Kalyanwala", :"Kayonaaz Kalyanwala"],
     ["Purnima Damade", :"Purnima Damade"], ["Ajeet Bahadur", :"Ajeet Bahadur"],
     ["Achintya Rai", :"Achintya Rai"], ["Sameer Malik", :"Sameer Malik"],
     ["Edward Fernandes", :"Edward Fernandes"],
     ["Anshuman Singh", :"Anshuman Singh"], ["Anand Pagare", :"Anand Pagare"],
     ["Vidyadhar Ketkar", :"Vidyadhar Ketkar"],
     ["Sajad Rasool", :"Sajad Rasool"]].sort
  end

  def edit_status_collection
    [["story pitched (no footage yet)", :"story pitched (no footage yet)"],
     ["footage received", :"footage received"],
     ["footage rated and approved for payment", :"footage rated and approved for payment"],
     ["footage on hold", :"footage on hold"],
     ["footage to edit’", :"footage to edit’"],
     ["‘rough cuts to clean’", :"‘rough cuts to clean’"],
     ["rough cuts to review", :"rough cuts to review"],
     ["to finalize and upload", :"to finalize and upload"],
     ["uploaded", :uploaded], ["edit on hold", :"edit on hold"],
     ["problem video", :"problem video"]]
  end

  def subtitle_collection
    [["Has subtitles", :"Has subtitles"],
     ["High priority subtitle", :"High priority subtitle"],
     ["Low priority subtitle", :"Low priority subtitle"],
     ["Don't subtitle", :"Don't subtitle"]]
  end

  def editor_changes_collection
    [["Required", :"Required"],
     ["Suggested", :"Suggested"],
     ["Not needed", :"Not needed"],
     ["No further edits required", :"No further edits required"]]
  end

  def translation_collection
    [["Required", :"Required"],
     ["Needed and provided", :"Needed and provided"],
     ["Needed & not provided", :"Needed & not provided"]]
  end

  def impact_status_collection
    [["Not done yet", :"Not done yet"],
     ["In progress", :"In progress"],
     ["Completed", :"Completed"],
     ["CC not planning to make", :"CC not planning to make"]]
  end

  def divisions_collection
    [["State Coordinator", :"State Coordinator"],
     ["Training & Mentoring", :"Training & Mentoring"],
     ["Communications", :"Communications"], ["Production", :"Production"],
     ["Executive Directors", :"Executive Directors"]]
  end
end
