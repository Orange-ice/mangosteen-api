class Api::V1::ValidateCodesController < ApplicationController
  def create
    if ValidateCode.exists?(email: params[:email], created_at: 1.minute.ago..Time.now)
      render status: :too_many_requests
      return
    end

    validate_code = ValidateCode.new email: params[:email]
    if validate_code.save
      render status: :created
    else
      render json: { errors: validate_code.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
