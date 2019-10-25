class SvgIconUploader < IconUploader

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w[svg]
  end

end
