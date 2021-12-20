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
      item = Item.new(item_params)
      if item.save
       redirect_to admin_item_path(item.id)
      else
       render 'new'
      end
    end
    
    def edit
     @item = Item.find(params[:id])
    end
    
    def update
     item = Item.find(params[:id])
     item.update(item_params)
     redirect_to admin_item_path
    end
    
    private
    
    def item_params
     params.require(:item).permit(:item_name, :image, :genre_id, :introduction, :is_sales_status, :price_without_tax)
    end 


end
