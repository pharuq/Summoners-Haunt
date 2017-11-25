class PictureUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  # process resize_to_limit: [240, 240]
  process :crop
  process resize_to_fill: [240, 240]
  # process resize_and_pad: [240, 240, "#000", "Center"]

  version :thumb do
    # process resize_to_limit: [80, 80]
    # process resize_and_pad: [80, 80, "#000", "Center"]
    # process :crop
    process resize_to_fill: [80, 80]
  end

  version :mini_thumb do
    # process resize_to_limit: [80, 80]
    # process resize_and_pad: [24, 24, "#000", "Center"]
    process resize_to_fill: [24, 24]
  end

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end


  private

    def crop
      p "TEST1"
      p  "model.image_x:", model.image_x, "model.image_y:", model.image_y,
          "model.image_w:", model.image_w,"model.image_h:", model.image_h
      return unless [model.image_x, model.image_y, model.image_w, model.image_h].all?
      p "TEST2"
      manipulate! do |img|
        crop_x = model.image_x.to_i
        crop_y = model.image_y.to_i
        crop_w = model.image_w.to_i
        crop_h = model.image_h.to_i
        img.crop "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"
        img = yield(img) if block_given?
        p "TEST3"
        p  "crop_x:", crop_x, "crop_y:", crop_y,"crop_w:", crop_w,"crop_h:", crop_h
        img
      end
    end

end
