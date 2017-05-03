class Setting < ApplicationRecord
  validates :lock, format: /X/
end
