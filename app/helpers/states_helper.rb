module StatesHelper

  def name_modifier(x)
    !state_label(x).nil? ? state_label(x) : x.split('_').map(&:capitalize).join(' ')
  end

  def state_label(x)
    labels =  { 'state_abb' => "State Abbreviation"}
    !labels[x].nil? ? labels[x] : nil
  end

end
