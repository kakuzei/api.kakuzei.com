class PicturesController < ApplicationController
  def index
    render json: Picture.all
  end

  def show
    if params[:format] == 'jpg'
      dpi = params[:id].last(3) == '@2x' ? :high_dpi : :low_dpi
      id = dpi == :high_dpi ? params[:id][0..-4] : params[:id]
      picture = read_picture(Picture.find(id), dpi)
      response.headers['Expires'] = 1.year.from_now.httpdate
      response.headers['Content-Type'] = 'image/jpeg'
      render plain: picture
    elsif params[:format] == 'json'
      render json: Picture.find(params[:id])
    end
  end

  private

  def read_picture(picture, dpi)
    IO.binread(file_path(picture.id, dpi)).tap do |raw_file|
      fail 'Invalid checksum' unless valid_checksum?(dpi, picture, Digest::SHA2.hexdigest(raw_file))
    end
  end

  def file_path(name, dpi)
    extension = dpi == :high_dpi ? '@2x.jpg' : '.jpg'
    File.join(Setting.take.path, "#{name}#{extension}")
  end

  def valid_checksum?(dpi, picture, checksum)
    checksum == (dpi == :low_dpi ? picture.low_resolution_checksum : picture.high_resolution_checksum)
  end
end