class AllOtherController < ApplicationController
  def index
    render json: { message: 'Not Found' }, status: :not_found
  end
end
