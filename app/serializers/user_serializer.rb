class UserSerializer < Blueprinter::Base
  fields :email,
         :phone_number,
         :full_name,
         :key,
         :account_key,
         :metadata
end
