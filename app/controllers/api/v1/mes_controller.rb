class Api::V1::MesController < ApplicationController
  def show
    user_id = request.env['current_user_id']
    reutun render status: :unauthorized unless user_id

    user = User.find(user_id)
    return render status: :not_found unless user
    render status: :ok, json: { resource: user }
  end
end
