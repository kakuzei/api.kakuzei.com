class PictureSerializer < ApplicationSerializer
  attributes %i[id code name date_taken high_density_available]
  has_many :tags

  link(:self) { "api/pictures/#{object.id}" }
  link(:src) { "api/pictures/#{object.id}.jpg" }
  link(:high_density_src) { "api/pictures/#{object.id}@2x.jpg" if object.high_density_checksum }

  def tags
    object.tags.order(:name)
  end

  def high_density_available
    !object.high_density_checksum.nil?
  end
end
