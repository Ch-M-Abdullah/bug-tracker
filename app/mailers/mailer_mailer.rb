class MailerMailer < ApplicationMailer
  default from: "chmabdullah58@gmail.com"

  def bug_fixed(user)
    @user = user
    @bug = bug
    mail(to: @user.email, subject: "Bug Has Been Fixed")
  end
end
