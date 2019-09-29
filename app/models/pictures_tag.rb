class PicturesTag < ApplicationRecord
  belongs_to :picture
  belongs_to :tag
end
