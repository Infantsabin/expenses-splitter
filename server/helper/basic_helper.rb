class Helper
    def self.secure_password password
        BCrypt::Password.create(password)
    end

    def self.decrypt_password password
        BCrypt::Password.new(password)
    end

    def self.secure_token
        Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3)
    end
end