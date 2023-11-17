class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = 'Category added.'
      redirect_to admin_categories_path
    else
      flash[:alert] = 'Category saving failed.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = 'Category updated.'
      redirect_to admin_category_path
    else
      flash[:alert] = 'Category update failed.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = 'Category deleted.'
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
