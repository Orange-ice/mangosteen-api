class Api::V1::BillsController < ApplicationController
  def index
    user_id = request.env['current_user_id']
    return render status: :unauthorized unless user_id
    bills = Bill.where(user_id: user_id, created_at: params[:start_date]..params[:end_date])
      .page(params[:page]).per(params[:per_page])
    
    render status: :ok, json: { resources: bills, pager: {
      page: params[:page] || 1,
      per_page: params[:per_page] || Bill.default_per_page,
      count: bills.total_count
    } }
  end
end
