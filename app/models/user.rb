class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         validate :validate_username
         has_many :orders
         def validate_username
           if User.where(email: username).exists?
             errors.add(:username, :invalid)
           end
         end
        def display_name
           if self.username.present?
             self.username
           else
             self.email.split("@").first
           end
         end
         def login=(login)
            @login = login
          end

        def login
          @login || self.username || self.email
        end
        def self.find_first_by_auth_conditions(warden_conditions)
         conditions = warden_conditions.dup
         if login = conditions.delete(:login)
         where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
         else
          if conditions[:username].nil?
          where(conditions).first
           else
          where(username: conditions[:username]).first
         end
        end
     end
     def admin?
       is_admin
     end
end
