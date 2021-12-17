class Admin::ItemsController < ApplicationController
    def top
        
    end
    
    def index
     @items = Item.all
    end
    
    def show
     @item = Item.find(params[:id])
    end
    
    def new
     @item = Item.new
    end
    
    def create
      cart = Cart_item.new(params[:id])
      cart.save
      #ここに商品詳細に飛ぶリンク
    end
    
    
    def item_params
     params.require(:item).permit(:item_name, :image, :genre, :introduction, :is_sales_status, :price_without_tax)
    end 


end
