module UsersHelper

  def user_name_modifier(x)
    x.split.map(&:capitalize).join(' ')
  end
end
