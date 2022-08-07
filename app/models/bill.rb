class Bill < ApplicationRecord
  enum kind: { expense: 1, income: 2 }
  # amount, kind, tag_id, happened_at required
  validates :amount, :kind, :tag_id, :happened_at, presence: true

  validate :check_tag_id_belongs_to_user
  def check_tag_id_belongs_to_user
    tag_ids = Tag.where(user_id: self.user_id).map(&:id)
    # 如果tag_id存在并且不在tag_ids中
    if self.tag_id && !tag_ids.include?(self.tag_id)
      errors.add(:tag_id, "tag_id is invalid")
    end
  end
end
