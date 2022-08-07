class Bill < ApplicationRecord
  enum kind: { expense: 1, income: 2 }
end
