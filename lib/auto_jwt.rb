# jwt 中间件
class AutoJwt
  def initialize(app)
    @app = app
  end

  def call(env)
    jwt = env['HTTP_AUTHORIZATION'].split(' ').last rescue ''
    payload = JWT.decode(jwt, Rails.application.credentials.hmac_secret, true, algorithm: 'HS256') rescue nil
    env['current_user_id'] = payload[0]['user_id'] rescue nil
    @app.call(env)
  end
end