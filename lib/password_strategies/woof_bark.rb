require 'bcrypt'

module PasswordStrategies
  module WoofBark
    def authenticated?(password)
      woof_bark_authenticated?(password) || bcrypt_authenticated?(password)
    end

    def woof_bark_authenticated?(password)
      return unless encrypted_password == encrypt(password)

      self.password = password
      save!
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    # copied from Clearance::PasswordStrategies::BCrypt
    def password=(new_password)
      return if new_password.blank?

      @password = new_password

      cost = if defined?(::Rails) && ::Rails.env.test?
        ::BCrypt::Engine::MIN_COST
      else
        ::BCrypt::Engine::DEFAULT_COST
      end

      self.encrypted_password = ::BCrypt::Password.create(
        new_password,
        cost: cost
      )
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    private

    def bcrypt_authenticated?(password)
      return if encrypted_password.blank?
      return unless encrypted_password.starts_with?('$2$')

      ::BCrypt::Password.new(encrypted_password) == password
    end
  end
end
