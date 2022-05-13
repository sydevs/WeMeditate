require 'test_helper'

class MonkeyPatchesTest < ActiveSupport::TestCase

  test 'public_url of GcloudFile uploads includes asset version query string' do
    CarrierWave.configure do |config|
      config.storage = :gcloud
    end

    stub_request(:post, 'https://oauth2.googleapis.com/token')
      .to_return(
        status: 200,
        body: { access_token: 'foo', refresh_token: 'bar' }.to_json,
        headers: { "Content-Type": 'application/json' }
      )
    file_name = 'test.svg'
    result = MediaFile.insert(
      file: file_name,
      page_type: 'StaticPage',
      page_id: 1,
      meta: { width: 640, height: 480 }.to_json,
      created_at: Time.now,
      updated_at: Time.now
    )

    media_file = MediaFile.find(result.first.fetch('id'))

    host = "https://#{ENV.fetch('GCLOUD_BUCKET')}"
    query_string = "version=#{Rails.application.config.assets.version}"
    expected_url = "#{host}/uploads/media_file/file/#{media_file.id}/#{file_name}?#{query_string}"

    assert_equal expected_url, media_file.file.url
  end

end
