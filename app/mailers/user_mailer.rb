class UserMailer < ApplicationMailer
  def welcome_email(code, email)
    @code = code
    mail(to: email, subject: '山竹记账系统验证码')
  end
end
 