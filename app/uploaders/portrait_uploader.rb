class PortraitUploader < BaseImageUploader
  process resize_to_fill: [300, 300]

  version :thumb do
    process resize_to_fill: [150, 150]
  end
end
