module PasswordStrategies
  module WoofBark
    def authenticated?(password)
      has_password?(password)
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def password=(new_password)
      self.salt = make_salt unless has_password?(new_password)
      self.encrypted_password = encrypt(new_password)
    end

    def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
  end
end
