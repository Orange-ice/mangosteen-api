class ValidateCode < ApplicationRecord
  validates :email, presence: true
end
