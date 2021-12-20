class Public::ItemsController < ApplicationController
    def index
      @items = Item.all
    end
    
    def show
      @item = Item.find(params[:id])
      @cart_item = CartItem.new
    end
    
    def create
      cart = Cart_item.new(params[:id])
      cart.save
      redirect_to customers_cart_items_path(cart_item.id)
    end
end

private

def item_params
   params.require(:item).permit(:item_name, :image, :genre, :introduction, :is_sales_status, :price_without_tax)
end 

def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount,)
end
