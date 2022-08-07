class Api::V1::TagsController < ApplicationController
  def index
    user_id = request.env['current_user_id']
    tags = Tag.where(user_id: user_id)
    render json: { resources: tags }
  end

  def create
    user_id = request.env['current_user_id']
    tag = Tag.new(name: params[:name], sign: params[:sign], user_id: user_id)
    if tag.save
      render json: { resource: tag }, status: :created
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
