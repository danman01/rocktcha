class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  easy_roles :roles
  # admin and [] for now...

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :songs
  accepts_nested_attributes_for :songs, :allow_destroy => true
  
end
