class BaseImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def extension_white_list
    %w(jpg jpeg gif)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def default_url
    "/images/fallback/#{model.class.to_s.underscore}/" +
        [mounted_as, version_name, 'default.jpg'].compact.join('_')
  end

  protected

    def secure_token
      name = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(name) || model.instance_variable_set(name, SecureRandom.uuid)
    end

end
