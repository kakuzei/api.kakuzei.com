class Tag < ApplicationRecord
  has_many :pictures_tags, dependent: :destroy
  has_many :pictures, through: :pictures_tags
end
