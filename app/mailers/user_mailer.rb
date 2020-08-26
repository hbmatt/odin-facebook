class UserMailer < ApplicationMailer
  default from: 'notifications@odinbook.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to OdinBook')
  end
end
