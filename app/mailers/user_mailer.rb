class UserMailer < ApplicationMailer
  def welcome_email(email)
    # find 只会找第一个
    validate_code = ValidateCode.order(created_at: :desc).find_by_email(email)
    @code = validate_code.code
    mail(to: email, subject: '山竹记账系统验证码')
  end
end
 