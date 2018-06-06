class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :destroy, :update, :edit]

  def index
    @categories = Category.paginate(page: params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Created successfully'
      return redirect_to categories_path
    end
    flash.now[:danger] = 'Have some errors'
    render :new
  end

  def show
    @products = @category.products.paginate(page: params[:page])
  end

  def edit

  end

  def destroy
    flash[:warning] = 'Category and all product in it have been destroyed' if @category.destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

end
