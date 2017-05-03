class PictureSerializer < ApplicationSerializer
  attributes %i[id code name date_taken high_resolution_available]
  has_many :tags

  def high_resolution_available
    !!object.high_resolution_checksum
  end
end
