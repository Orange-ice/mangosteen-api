# jwt 中间件
class AutoJwt
  def initialize(app)
    @app = app
  end

  def call(env)
    # 以下路径跳过 jwt 验证
    white_list = ['/api/v1/session', '/api/v1/validate_codes']
    return @app.call(env) if white_list.include?(env['PATH_INFO'])

    jwt = env['HTTP_AUTHORIZATION'].split(' ').last rescue ''
    begin
    payload = JWT.decode(jwt, Rails.application.credentials.hmac_secret, true, algorithm: 'HS256')
    rescue JWT::ExpiredSignature
      return [401, {}, [{ reason: 'token expired' }.to_json]]
    rescue
      return [401, {}, [{ reason: 'token invalid' }.to_json]]
    end
    env['current_user_id'] = payload[0]['user_id'] rescue nil
    @app.call(env)
  end
end