class CoverUploader < BaseImageUploader
  process resize_to_fill: [300, 450]

  version :thumb do
    process resize_to_fill: [150, 300]
  end
end
