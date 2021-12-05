DIGEST = Digest::SHA2.new

namespace :kakuzei do
  desc 'Initialize the database with provided data'
  task :init, %i[path] => %i[environment] do |_, args|
    path = args[:path] || Rails.root.join('data')
    reset_database
    insert_settings(path)
    insert_tags(path)
    insert_pictures(path)
    puts "\n#{Picture.count} pictures, #{Tag.count} tags inserted"
  end
end

def insert_settings(path)
  puts 'Insert settings data'
  insert(Setting, path: picture_path(path))
end

def insert_tags(path)
  puts 'Insert tags data'
  load_data(path, 'tags').each do |tag|
    puts " - insert tag '#{tag[:name]}'"
    insert(Tag, tag)
  end
end

def insert_pictures(path) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  puts 'Insert pictures data'
  load_data(path, 'pictures').each do |picture|
    tags = picture.delete(:tags)
    puts " - insert picture '#{picture[:name]}' with tags #{tags.map { |t| "'#{t[:name]}'" }.join(', ')}"
    picture[:low_density_checksum] = checksum(path, picture[:id], '')
    picture[:high_density_checksum] = checksum(path, picture[:id], '@2x')
    insert(Picture, picture)
    tags.map { |tag| Tag.find_by(tag).id }.each do |tag_id|
      insert(PicturesTag, tag_id: tag_id, picture_id: picture[:id])
    end
  end
end

def insert(model, attributes)
  model.create!(attributes)
end

def checksum(path, id, density)
  file = File.join(picture_path(path), "#{id}#{density}.jpg")
  DIGEST.hexdigest(File.binread(file)) if File.exist? file
end

def picture_path(path)
  File.join(path, 'pictures')
end

def load_data(path, file)
  YAML.load_file(File.join(path, "#{file}.yml"))
end

def reset_database
  ActiveRecord::Tasks::DatabaseTasks.env = Rails.env
  Rake::Task['db:drop'].execute
  Rake::Task['db:create'].execute
  Rake::Task['db:migrate'].execute
end
