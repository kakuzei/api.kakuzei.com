class Setting < ApplicationRecord
  validates :lock, format: { with: /X/, multiline: false }
end
