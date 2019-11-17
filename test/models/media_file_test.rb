require 'test_helper'

class MediaFileTest < ActiveSupport::TestCase

  test 'image file versions' do
    file = MediaFile.create!(
      file: File.open('test/fixtures/files/image.jpg'),
      page: articles(:one)
    ).file

    # 5 major versions
    assert_equal 5, file.versions.length

    # 1 webp version of each
    file.versions.each do |version|
      # version => {:type => <MediaFileUploader::Uploader>}
      assert_equal :webp, version.second.versions.first.first
    end
  end

end
