module Public::CustomersHelper
    
  def full_name(customer)
    "#{customer.last_name} #{customer.first_name}"
  end
  
  def kana_full_name(customer)
    "#{customer.last_name} #{customer.first_name}"
  end

end
