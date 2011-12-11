class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  version :puffer do
    process :resize_to_fill => [100, 100]
  end
end