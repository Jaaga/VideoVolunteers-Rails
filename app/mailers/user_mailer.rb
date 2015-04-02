class UserMailer < ApplicationMailer

  def new_user_approval(user)
    @user = user
    @admin = User.find_by(email: 'jessica@videovolunteers.org')
    mail to: @admin.email, subject: "New User Approval"
  end
end
