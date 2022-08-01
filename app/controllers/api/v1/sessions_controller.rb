require 'jwt'
class Api::V1::SessionsController < ApplicationController
  def create

    if Rails.env.test?
      # 测试环境 code 只能为 123456
      return render status: :unauthorized unless params[:code] == '123456'
    else
      # 验证码有效期 3 分钟
      canSignin = ValidateCode.exists?(email: params[:email], code: params[:code], used_at: nil, created_at: 3.minute.ago..Time.now)
      # 如果不能登录，则返回错误信息 （unless 除.... 之外）
      return render status: :unauthorized unless canSignin
    end

    user = User.find_by(email: params[:email])
    if user.nil?
      render status: :not_found, json: { errors: '用户不存在' }
    else
      payload = { user_id: user.id }
      token = JWT.encode payload, Rails.application.credentials.hmac_secret, 'HS256'
      render status: :ok, json: { jwt: token }
    end
  end
end
