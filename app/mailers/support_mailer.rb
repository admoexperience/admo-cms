class SupportMailer < ActionMailer::Base
  default from: Settings.email.from

  def help(params)
    @subject = params[:subject]
    @message = params[:message]
    @user_email = params[:user_email]
    mail(to: Settings.support.email, subject: '[Support] Website Request')
  end
end
