class Picture < ApplicationRecord
  has_many :pictures_tags, dependent: :destroy
  has_many :tags, through: :pictures_tags
end
