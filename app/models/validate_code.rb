class ValidateCode < ApplicationRecord
  validates :email, presence: true

  # 钩子函数
  # 创建之前
  before_create :generate_code

  # 创建之后，发送邮件
  after_create :send_email

  def generate_code
    self.code = SecureRandom.random_number.to_s[2..7]
  end

  def send_email
    UserMailer.welcome_email(self.email)
  end
end
