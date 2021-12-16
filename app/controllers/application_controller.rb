class ApplicationController < ActionController::Base
#before_action :configure_permitted_parameters, if: :devise_controller?
    
    def index
     @item = Item.new
     @items = Iten.all
    end
    
    def new
     @item = Item.new
    end
    
    def create
    end
    
  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  private

  # before_action作成

  def set_product
    @product = Product.find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end
end
