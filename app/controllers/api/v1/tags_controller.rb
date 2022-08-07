class Api::V1::TagsController < ApplicationController
  def index
    user_id = request.env['current_user_id']
    tags = Tag.where(user_id: user_id)
    render json: { resources: tags }
  end
end
