class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  #Relations
  has_many :lists, :dependent => :destroy
  has_many :favorites, :dependent => :destroy

  def my_favorites
    List.joins(:favorites => [:user]).where(:users => {:id => self.id})
  end

  def this_is_my_favorite_list?(list)
    self.favorites.where(:list_id => list.id).size > 0
  end

end
