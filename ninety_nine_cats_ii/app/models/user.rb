require 'bcrypt'

class User < ApplicationRecord 
  validates :username, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :session_token, presence: true, uniqueness: true
  after_initialize :ensure_session_token 
  attr_reader :password
  
  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat
  
  def reset_session_token! 
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end 
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end 
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end 
  
  def self.find_by_credentials(user_name, password)  
    user = User.find_by(username: user_name)
    user && user.is_password?(password) ? user : nil
  end  
  
  private 
  
  def ensure_session_token 
    self.session_token ||= SecureRandom.urlsafe_base64
  end 
  
end 