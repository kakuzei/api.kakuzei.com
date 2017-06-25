class TagSerializer < ApplicationSerializer
  attributes %i[id name]
  has_many :pictures

  link(:self) { "api/tags/#{object.id}" }

  def pictures
    object.pictures.sort_by(&:date_taken).reverse
  end
end
