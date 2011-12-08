class UserMailer < ActionMailer::Base
  default from: "coMeeting@comeeting.com"

  #� para apagar o campo email, e passar a receber s� o admin (que � um user). Para aceder ao campo email, � s� fazer admin[:email]
  def admin_email(email, admin, token)
  	mail(:to => email, :subject => t("email.admin.subject", :default => "Your administration link"), :body => "#{ENV['HOST']}/meetings/#{token}")
  end

  def invitation_email(email, admin, token)
    mail(:to => email, :subject => t("email.participant.subject", :default => "You were invited by #{admin[:name]} for a meeting"), :body => "#{ENV['HOST']}/meetings/#{token}")
  end

end
