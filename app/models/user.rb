require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password

  attr_accessible :name, 
                  :email, 
                  :password, 
                  :password_confirmation,
                  :admin,
                  :is_foster,
                  :phone,
                  :address1,
                  :address2,
                  :city,
                  :state,
                  :zip,
                  :title,
                  :edit_adopters,
                  :edit_dogs,
                  :share_info,
                  :view_adopters
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }
  
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                    
  #Automatically creates the virtual attribute 'password_confirmation'.
  validates :password, :presence      => true,
                       :confirmation  => true,
                       :length        => { :within => 8..40 },
                       :unless => Proc.new { |a| a.password.blank? }
                       
  before_save :encrypt_password, :unless => "password.blank?"

  has_many :histories
  has_many :dogs
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end  
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.password_reset(self).deliver
  end

  private

    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")  
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

  
end
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)
#  salt                   :string(255)
#  admin                  :boolean         default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  is_foster              :boolean         default(FALSE)
#  phone                  :string(255)
#  address1               :string(255)
#  address2               :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  zip                    :string(255)
#  title                  :string(255)
#  edit_adopters          :boolean         default(FALSE)
#  edit_dogs              :boolean         default(FALSE)
#  view_adopters          :boolean         default(FALSE)
#  share_info             :text
#

