class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  has_many :services, :dependent => :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :haslocalpw
  attr_accessible :location, :gender

  validates :firstname, :length => { :maximum => 40 }
  validates :lastname, :length => { :maximum => 40 }

  scope :male, where(:gender => 'Male')
  scope :female, where(:gender => 'Female')
  scope :confirmed, where('confirmed_at is not null')
  scope :unconfirmed, where(:confirmed_at => nil)
end
