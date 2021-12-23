class Order < ApplicationRecord

  belongs_to :customer
  has_many :order_items, dependent: :destroy

	#validates :customer_id, :address,:name, :shipping_cost,:total_payment, :payment_method, presence: true

	#validates :post_code, length: {is: 7}, numericality: { only_integer: true }
	#validates :shipping_cost, :total_payment, numericality: { only_integer: true }

	enum payment_method: { credit_card: 0, transfer: 1 }
	enum order_status: {"waiting_deposit": 0,"payment_confirmation": 1,"in_production": 2,"preparing_ship": 3, "sent": 4}

end
