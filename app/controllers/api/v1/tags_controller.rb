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

  def show
    tag = Tag.find(params[:id])
    # 不允许获取其他用户的标签
    return render status: :not_found unless tag.user_id == request.env['current_user_id']
    render json: { resource: tag }
  end

  def update
    tag = Tag.find(params[:id])
    # 不允许更新其他用户的标签
    return render status: :not_found unless tag.user_id == request.env['current_user_id']
    tag.update params.permit(:name, :sign)
    if tag.errors.empty?
      render json: { resource: tag }
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    # 不允许删除其他用户的标签
    return render status: :not_found unless tag.user_id == request.env['current_user_id']
    tag.deleted_at = Time.now
    return render json: {errors: tag.errors}, status: :unprocessable_entity unless tag.save
    render status: 200
  end
end
