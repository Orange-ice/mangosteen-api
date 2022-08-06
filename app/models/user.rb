class User < ApplicationRecord
  validates :email, presence: true

  def generate_jwt
    payload = { user_id: self.id, exp: 2.hours.from_now.to_i }
    JWT.encode payload, Rails.application.credentials.hmac_secret, 'HS256'
  end

  def generate_auth_header
    { Authorization: "Bearer #{self.generate_jwt}" }
  end
end
