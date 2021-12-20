class ApplicationController < ActionController::Base
before_action :configure_permitted_parameters, if: :devise_controller?
    
    def index
     @item = Item.new
     @items = Item.all
    end
    
    def new
     @item = Item.new
    end
    
    def create
    end
  
  def after_sign_in_path_for(resource)
      case resource
      when Admin
      root_path
      when Customer
      root_path
      end
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  
  # 新規登録の保存機能
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,
  			 keys: [:first_name, :last_name, :kana_first_name, :kana_last_name,
                :email, :post_code, :address, :telephone_number])

      #sign_upの際にnameのデータ操作を許。追加したカラム。
  		devise_parameter_sanitizer.permit(:sign_in, keys: [:email])

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
