#TODO Remove once upgraded to Rails 4

ActiveRecord::Base.class_eval do
  include ActiveModel::ForbiddenAttributesProtection
end