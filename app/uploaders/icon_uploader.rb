class IconUploader < ApplicationUploader

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w[png svg]
  end

end
