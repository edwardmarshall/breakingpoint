class UserMailer < ActionMailer::Base
  default from: "H&S Performance <noreply@hsbreakingpoint.com>"

  def congratulations_email(user)
  	@user = user
  	mail(:to => user.email, :subject => "Welcome to Breaking Point 2!")
  end
end
