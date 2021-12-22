class Item < ApplicationRecord
    belongs_to :genre
	   has_many :cart_items
   	has_many :orders, through: :order_items
   	has_many :order_items
    #画像読み込む為の物
    attachment :image
    
   #商品追加の際のバリデーション
    validates :item_name, presence: true
    validates :image, presence: true
    validates :genre_id, presence: true
    validates :introduction, presence: true
    validates :price_without_tax, presence: true
    
    def with_tax_price
     (price_without_tax * 1.1).floor
    end
end
