class UserMailer < ApplicationMailer
  def welcome_email(code)
    @code = code
    mail(to: '2902978956@qq.com', subject: 'Welcome to My Awesome Site')
  end
end
 