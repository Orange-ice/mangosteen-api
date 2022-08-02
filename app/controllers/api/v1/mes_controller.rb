class Api::V1::MesController < ApplicationController
  def show
    jwt = request.headers['Authorization'].split(' ').last rescue ''
    payload = JWT.decode(jwt, Rails.application.credentials.hmac_secret, true, algorithm: 'HS256') rescue nil
    reutun render status: :unauthorized unless payload
    user_id = payload[0]['user_id'] rescue nil
    user = User.find(user_id)
    return render status: :not_found unless user
    render status: :ok, json: { resource: user }
  end
end
