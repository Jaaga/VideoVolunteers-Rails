module StatesHelper

  # Used to capitalize each segment of names and other words along with column
  # names. If the column name won't do for display, a custom one is given in the
  # state_label method.
  def state_name_modifier(x)
    !state_label(x).nil? ? state_label(x) : x.split('_').map(&:capitalize).join(' ')
  end

  # Gives custom labels to the column names in the labels hash.
  def state_label(x)
    labels =  { 'state_abb' => "State Abbreviation"}
    !labels[x].nil? ? labels[x] : nil
  end

end
