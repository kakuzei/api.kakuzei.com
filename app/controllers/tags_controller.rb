class TagsController < ApplicationController
  def index
    render json: Tag.order(:name)
  end

  def show
    render json: Tag.find(params[:id])
  end
end
