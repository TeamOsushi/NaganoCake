class Public::ItemsController < ApplicationController
    def index
      @items = Item.all
    end
    
    def show
      @item = Item.find(params[:id])
    end
    
    def create
      cart = Cart_item.new(params[:id])
      cart.save
    end
end

private

def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount,)
end
