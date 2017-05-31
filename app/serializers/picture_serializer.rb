class PictureSerializer < ApplicationSerializer
  attributes %i[id code name date_taken high_resolution_available]
  has_many :tags

  link(:self) { "api/pictures/#{object.id}" }
  link(:src) { "api/pictures/#{object.id}.jpg" }
  link(:high_resolution_src) { "api/pictures/#{object.id}@2x.jpg" if object.high_resolution_checksum }

  def high_resolution_available
    !object.high_resolution_checksum.nil?
  end
end
