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

      it 'returns the available pictures in the reverse order of the taken date' do
        expect(json).to eq(data: sorted_json_pictures)
      end
    end

    describe 'when a tag id is povided' do
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

      it 'returns the pictures that are linked to the provided tag in the reverse order of the taken date' do
        expect(json).to eq(data: sorted_json_pictures)
      end
    end
  end

  describe 'show' do
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
end
