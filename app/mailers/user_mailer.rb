class UserMailer < ApplicationMailer

  def new_user_approval(user)
    @user = user
    # @admin = User.find_by(email: 'jessica@videovolunteers.org')
    mail to: 'jessica@videovolunteers.org', subject: "New User Approval"
  end
end
