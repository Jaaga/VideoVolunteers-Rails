module CcsHelper

  def name_modifier(x)
    x.split('_').map(&:capitalize).join(' ')
  end
end
