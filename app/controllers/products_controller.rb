class ProductsController < ApplicationController

  before_action :fetch_product, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[create_product]

  def new
    @product = Product.new
  end

  def index
    @products = current_user.products.all.order('created_at DESC')
  end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render 'new'
    end
  end

  def edit; end

  def show; end

  def update
    if @product.present?
      if @product.update_attributes(product_params)
        redirect_to products_path
      else
        render 'edit'
      end
    end
  end

  def destroy
    @product.destroy if @product.present?
    redirect_to products_path
  end

  def create_product
    user = User.find_by(authentication_token: params[:authentication_token])
    if user.present?
      product = user.products.new(product_params)
      if product.save
        render json: { success: true, message: "Product is created successfully!" }, status: 201
      else
        render json: { success: false, message: "Validation failed" }, status: 422
      end
    else
      render json: { success: false, message: "Token is invalid" }, status: 400
    end
  end

  def import
    csv_path = params[:file].path
    ProductAddWorker.perform_async(csv_path)
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :user_id)
  end

  def fetch_product
    @product = Product.find_by(id: params[:id])
  end
end
