class TagSerializer < ApplicationSerializer
  attributes %i[id name]
  has_many :pictures

  link(:self) { "api/tags/#{object.id}" }
end
