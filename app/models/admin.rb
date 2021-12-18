class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, # :registerable,　　⇦ここの部分
         :recoverable, :rememberable, :validatable
end