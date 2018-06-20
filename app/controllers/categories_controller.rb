class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    @categories = Category.paginate(page: params[:page])
  end

  def show
    @products = @category.products.paginate(page: params[:page])
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
