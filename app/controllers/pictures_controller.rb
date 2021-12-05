class PicturesController < ApplicationController
  def index
    pictures = params[:tag_id] ? Tag.find(params[:tag_id]).pictures : Picture.all
    render json: pictures.order(:date_taken).reverse_order
  end

  def show
    if params[:format] == 'jpg'
      response.headers['Expires'] = 1.year.from_now.httpdate
      render plain: picture_file, content_type: 'image/jpeg'
    else
      render json: Picture.find(params[:id])
    end
  end

  private

  def picture_file
    picture_params = picture_params(params[:id])
    read_picture_file(Picture.find(picture_params[:uuid]), picture_params[:density])
  end

  def read_picture_file(picture, density)
    File.binread(file_path(picture.id, density)).tap do |raw_file|
      raise Error::InvalidChecksum unless valid_checksum?(density, picture, Digest::SHA2.hexdigest(raw_file))
    end
  rescue Errno::ENOENT
    raise Error::FileNotFound
  end

  def file_path(name, density)
    @picture_path ||= Setting.take.path
    File.join(@picture_path, "#{name}#{density}.jpg")
  end

  def valid_checksum?(density, picture, checksum)
    checksum == (density ? picture.high_density_checksum : picture.low_density_checksum)
  end

  def picture_params(id)
    @uuid_matcher ||= Regexp.new(/^(?<uuid>[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})(?<density>@2x)?$/) # rubocop:disable Lint/MixedRegexpCaptureTypes
    @uuid_matcher.match(id).tap do |matches|
      raise ActiveRecord::RecordNotFound unless matches
    end
  end
end
