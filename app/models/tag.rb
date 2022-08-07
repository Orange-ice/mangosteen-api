class Tag < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { maximum: 32 }
  validates :sign, presence: true, length: { maximum: 32 }
  # 标签名不可重复
  validates :name, uniqueness: { scope: :user_id }
end
