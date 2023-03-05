require 'rails_helper'

RSpec.describe 'tags api' do
  describe 'index' do
    before { get '/api/tags' }

    describe 'when there is no tag available' do
      it 'responds with a 200 OK status' do
        expect(status).to eq 200
      end

      it 'returns an empty array' do
        expect(json).to eq(data: [])
      end
    end

    describe 'when there are some tags available' do
      fixtures :all

      before(:all) { DatabaseCleaner.start }

      after(:all) { DatabaseCleaner.clean }

      let :sorted_json_tags do
        %i[tag_1 tag_2 tag_3].map { |t| tags(t) }.sort_by(&:name).map { |t| fixture_to_json(t) }
      end

      it 'responds with a 200 OK status' do
        expect(status).to eq 200
      end

      it 'returns the available tags sorted by their names' do
        expect(json).to eq(data: sorted_json_tags)
      end
    end
  end

  describe 'show' do
    describe 'when the requested tag exists' do
      fixtures :all

      before(:all) { DatabaseCleaner.start }

      after(:all) { DatabaseCleaner.clean }

      before { get "/api/tags/#{tags(:tag_1).id}" }

      it 'responds with a 200 OK status' do
        expect(status).to eq 200
      end

      it 'returns the requested tag' do
        expect(json).to eq(data: fixture_to_json(tags(:tag_1)))
      end
    end

    describe 'when the requested tag does not exist' do
      before { get '/api/tags/cb3c2d56-6e17-4f61-954e-579ac4b4cc1a' }

      it 'responds with a 404 Not Found status' do
        expect(status).to eq 404
      end

      it 'returns an empty body' do
        expect(body).to be_empty
      end
    end

    describe 'when the requested tag id is not a UUID' do
      before { get '/api/tags/1' }

      it 'responds with a 400 Bad Request status' do
        expect(status).to eq 400
      end

      it 'returns an empty body' do
        expect(body).to be_empty
      end
    end
  end
end
