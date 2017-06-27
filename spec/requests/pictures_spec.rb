require 'rails_helper'

RSpec.describe 'pictures api', type: :request do
  describe 'index' do
    describe 'when there is no picture available' do
      before { get '/api/pictures' }

      it 'responds with a 200 OK status' do
        expect(status).to eq 200
      end

      it 'returns an empty array' do
        expect(json).to eq(data: [])
      end
    end

    describe 'when there are some pictures available' do
      before { get '/api/pictures' }

      fixtures :all
      before(:all) { DatabaseCleaner.start }
      after(:all) { DatabaseCleaner.clean }

      let :sorted_json_pictures do
        %i[picture_1 picture_2 picture_3]
          .map { |p| pictures(p) }
          .sort_by(&:date_taken).reverse
          .map { |p| fixture_to_json(p) }
      end

      it 'responds with a 200 OK status' do
        expect(status).to eq 200
      end

      it 'returns the available pictures in the reverse order of their taken dates' do
        expect(json).to eq(data: sorted_json_pictures)
      end
    end

    describe 'when a tag id is provided' do
      before { get "/api/tags/#{tags(:tag_2).id}/pictures" }

      fixtures :all
      before(:all) { DatabaseCleaner.start }
      after(:all) { DatabaseCleaner.clean }

      let :sorted_json_pictures do
        tags(:tag_2).pictures.sort_by(&:date_taken).reverse.map { |p| fixture_to_json(p) }
      end

      it 'responds with a 200 OK status' do
        expect(status).to eq 200
      end

      it 'returns the pictures that are linked to the provided tag in the reverse order of their taken dates' do
        expect(json).to eq(data: sorted_json_pictures)
      end
    end
  end

  describe 'show' do
    context 'when there is no format provided' do
      describe 'when the requested picture exists' do
        fixtures :all
        before(:all) { DatabaseCleaner.start }
        after(:all) { DatabaseCleaner.clean }

        before { get "/api/pictures/#{pictures(:picture_1).id}" }

        it 'responds with a 200 OK status' do
          expect(status).to eq 200
        end

        it 'returns the requested picture' do
          expect(json).to eq(data: fixture_to_json(pictures(:picture_1)))
        end
      end

      describe 'when the requested picture does not exist' do
        before { get '/api/pictures/cb3c2d56-6e17-4f61-954e-579ac4b4cc1a' }

        it 'responds with a 404 Not Found status' do
          expect(status).to eq 404
        end

        it 'returns an empty body' do
          expect(body).to be_empty
        end
      end

      describe 'when the requested picture id is not a UUID' do
        before { get '/api/pictures/1' }

        it 'responds with a 400 Bad Request status' do
          expect(status).to eq 400
        end

        it 'returns an empty body' do
          expect(body).to be_empty
        end
      end
    end

    RSpec.shared_examples 'manage picture requests when the jpg format provided' do |density|
      fixtures :all
      before(:all) do
        DatabaseCleaner.start
        Setting.create(path: File.join(__dir__, '..', 'data'))
      end
      after(:all) { DatabaseCleaner.clean }

      describe 'when the requested picture exists' do
        let(:picture) { "#{pictures(:picture_1).id}#{density}.jpg" }

        before { get "/api/pictures/#{picture}" }

        it 'responds with a 200 OK status' do
          expect(status).to eq 200
        end

        it 'returns the requested picture' do
          expect(body).to eq(IO.binread(File.join(__dir__, '..', 'data', picture)))
        end

        it 'responds with the image/jpeg content type' do
          expect(content_type).to eq 'image/jpeg'
        end

        it 'defines the expires date header to 1 year from now' do
          expect(Date.parse(response.headers['Expires'])).to be > Date.today + 1.year - 1.minute
        end
      end

      describe 'when the requested picture exists but the checksum is not valid' do
        before do
          Picture.find(pictures(:picture_1).id).update(low_density_checksum: '123', high_density_checksum: '456')
          get "/api/pictures/#{pictures(:picture_1).id}#{density}.jpg"
        end

        it 'responds with a 500 Internal Server Error status' do
          expect(status).to eq 500
        end

        it 'returns an empty body' do
          expect(body).to be_empty
        end
      end

      describe 'when the requested picture does not exist on the filesystem' do
        before { get "/api/pictures/#{pictures(:picture_2).id}#{density}.jpg" }

        it 'responds with a 404 Not Found status' do
          expect(status).to eq 404
        end

        it 'returns an empty body' do
          expect(body).to be_empty
        end
      end

      describe 'when the requested picture does not exist' do
        before { get "/api/pictures/cb3c2d56-6e17-4f61-954e-579ac4b4cc1a#{density}.jpg" }

        it 'responds with a 404 Not Found status' do
          expect(status).to eq 404
        end

        it 'returns an empty body' do
          expect(body).to be_empty
        end
      end

      describe 'when the requested picture id is not a UUID' do
        before { get "/api/pictures/1#{density}.jpg" }

        it 'responds with a 400 Bad Request status' do
          expect(status).to eq 400
        end

        it 'returns an empty body' do
          expect(body).to be_empty
        end
      end
    end

    describe 'when a low density picture is requested' do
      include_examples 'manage picture requests when the jpg format provided', ''
    end

    describe 'when a high density picture is requested' do
      include_examples 'manage picture requests when the jpg format provided', '@2x'
    end
  end
end
