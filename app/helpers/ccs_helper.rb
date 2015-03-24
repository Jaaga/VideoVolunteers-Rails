module CcsHelper

  # Used to capitalize each segment of names and other words that
  # need capitalization
  def cc_name_modifier(x)
    x.split('_').map(&:capitalize).join(' ')
  end
end
