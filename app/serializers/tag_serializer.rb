class TagSerializer < ApplicationSerializer
  attributes %i[id name]
  has_many :pictures
end
