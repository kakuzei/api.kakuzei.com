class CreateDatamodel < ActiveRecord::Migration[7.2]
  def change
    create_table :settings, id: false do |t|
      t.string :lock, default: 'X'
      t.string :path, null: false
    end
    add_index :settings, :lock, unique: true

    create_table :pictures, id: :uuid do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.datetime :date_taken, null: false
      t.string :low_density_checksum, null: false
      t.string :high_density_checksum
    end
    add_index :pictures, :date_taken, unique: true
    add_index :pictures, :low_density_checksum, unique: true
    add_index :pictures, :high_density_checksum, unique: true

    create_table :tags, id: :uuid do |t|
      t.string :name, null: false
    end
    add_index :tags, :name, unique: true

    create_table :pictures_tags, id: false do |t|
      t.string :tag_id, index: true
      t.string :picture_id, index: true
    end
  end
end
