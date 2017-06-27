module Requests
  module ResponseHelpers
    def body
      response.body
    end

    def content_type
      response.content_type
    end

    def json
      JSON.parse(body, symbolize_names: true)
    end

    def status
      response.status
    end
  end

  module FixtureHelpers
    def fixture_to_json(fixture)
      case fixture.class.to_s
      when 'Picture'
        picture_to_json(fixture)
      when 'Tag'
        tag_to_json(fixture)
      else
        raise "Unknown fixture class encountered: #{fixture.class}"
      end
    end

    private

    def picture_to_json(picture)
      tags_data = picture.tags.sort_by(&:name).map { |tag| { id: tag.id, type: 'tags' } }
      {
        id: picture.id,
        type: 'pictures',
        attributes: { code: picture.code, name: picture.name, dateTaken: picture.date_taken.as_json,
                      highDensityAvailable: picture.high_density_checksum ? true : false },
        relationships: { tags: { data: tags_data } },
        links: picture_link(picture)
      }
    end

    def picture_link(picture)
      links = picture.high_density_checksum ? { highDensitySrc: "api/pictures/#{picture.id}@2x.jpg" } : {}
      links.merge(self: "api/pictures/#{picture.id}", src: "api/pictures/#{picture.id}.jpg")
    end

    def tag_to_json(tag)
      pictures_data = tag.pictures.sort_by(&:date_taken).reverse.map { |picture| { id: picture.id, type: 'pictures' } }
      {
        id: tag.id,
        type: 'tags',
        attributes: { name: tag.name },
        relationships: { pictures: { data: pictures_data } },
        links: { self: "api/tags/#{tag.id}" }
      }
    end
  end
end
