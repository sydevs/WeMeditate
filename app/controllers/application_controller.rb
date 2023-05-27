require 'google/cloud/storage'

class ApplicationController < ActionController::Base

  include Regulator
  include Klaviyo
  protect_from_forgery prepend: true
  prepend_before_action :set_locale!
  before_action :enforce_maintenance_mode, except: %i[maintenance]
  skip_forgery_protection only: %i[contact subscribe] # Because of page caching

  # The root page of the website
  def home
    @static_page = StaticPage.preload_for(:content).find_by(role: :home)
    # return unless stale?(@static_page)

    set_custom_splash
    set_metadata(@static_page)
  end

  # The page where we embed a map from the program database
  def map
    # expires_in 1.year, public: true
    set_metadata({ 'title' => translate('classes.map_title') })

    countries = {
      ru: 'RU',
      cs: 'CZ',
      it: 'IT',
      ko: 'SK',
    }

    config = params.permit(:q, :country)
    config[:locale] = I18n.locale unless I18n.locale == :en
    config[:theme] = 'wemeditate'
    config[:country] ||= countries[I18n.locale]
    @atlas_url = "https://atlas.sydevelopers.com/map/embed.js?key=#{ENV.fetch('ATLAS_KEY')}&#{config.to_query}"
    @atlas_enabled = ENV['ATLAS_LOCALES'].split(',').include?(I18n.locale.to_s)
 
    render layout: 'minimal'
  end

  # A POST endpoint to submit a contact message to the site admins
  def contact
    contact_params = params.fetch(:contact, {}).permit(:email_address, :message, :gobbledigook)

    if !contact_params[:email_address].present?
      @message = I18n.translate('form.missing.email')
      @success = false
    elsif !contact_params[:message].present?
      @message = I18n.translate('form.missing.message')
      @success = false
    else
      contact = ContactForm.new(params[:contact])

      if verify_recaptcha(model: contact) && contact.deliver
        @message = I18n.translate('form.success.contact')
        @success = true
      else
        @message = contact.errors.full_messages.join(', ')
        @success = false
      end
    end
  end

  # A POST endpoint to subscribe to the site's mailing list.
  def subscribe
    if params[:signup][:email_address].present?
      email = params[:signup][:email_address].gsub(/\s/, '').downcase
      list_id = params[:signup][:list_id]
      language_code = I18n.locale.to_s.upcase
      country_code = request.headers['CF-IPCountry']

      begin
        Sendinblue.subscribe(
          email,
          list_id,
          first_referrer: request.referer,
          language: I18nData.languages[language_code],
          country: I18nData.countries[country_code]
        )

        @message = I18n.translate('form.success.subscribe')
        @success = true
      rescue Error => e
        @message = e.detail.to_s
        @success = false
      end
    else
      @message = I18n.translate('form.missing.email')
      @success = false
    end
  end

  # The page that users are redirected to if the site is in maintenance mode and they aren't logged in.
  def maintenance
    if current_user.present?
      redirect_to root_path
    else
      render layout: 'basic'
    end
  end

  # Renders an error page
  def error
    expires_in 1.month, public: true
    set_metadata({ 'title' => translate('errors.error') })
    render status: request.env['PATH_INFO'][1, 3].to_i
  end

  # An endpoint to serve up the sitemap for Google and other services.
  def sitemap
    expires_in 1.day, public: true

    # The sitemap itself is hosted on Google Cloud storage, we read it from them and send it back to the accessor of this endpoint.
    storage = Google::Cloud::Storage.new
    bucket = storage.bucket ENV.fetch('GCLOUD_BUCKET')
    file = bucket.file "sitemaps/sitemap.#{I18n.locale}.xml.gz"

    send_data file.download.read, type: 'text/xml'
  end

  protected

    def redirect_legacy_url record
      puts "REDIRECT URL FOR #{I18n.locale}/#{Globalize.locale}, #{record}"
      puts "REDIRECT URL #{request.path} == #{helpers.wm_path_for(record)}"
      return false if request.path == helpers.wm_path_for(record)

      redirect_to record, status: :moved_permanently
      true
    end

    def set_locale!
      I18n.locale = params[:locale]&.to_sym || :en
      Globalize.locale = params[:locale]&.to_sym || :en
    end

    # Allows us to use a different layout for the `devise` gem, which handles logins/user accounts
    def layout_by_resource
      devise_controller? ? 'devise' : 'application'
    end

    # Enforces the maintenance mode redirect
    def enforce_maintenance_mode
      return if !ENV['MAINTENANCE_MODE'] && Rails.configuration.published_locales.include?(I18n.locale)
      return if %w[sessions switch_user].include? controller_name
      return if current_user.present?

      redirect_to maintenance_path, status: :see_other
    end

    # Sets data which will be used to populate <meta> tags and structured data in the rendered page.
    def set_metadata record_or_hash
      if record_or_hash.is_a?(Hash)
        hash = record_or_hash
      else
        record = record_or_hash
      end

      @metatags = helpers.metatags(record)
      @metatags = hash.reverse_merge(@metatags) unless hash.nil?
      @structured_data = helpers.structured_data(record)
    end

    def set_custom_splash
      location = Geocoder.search(request.ip).first

      case location&.country_code
      when 'US', 'CA'
        @splash_style = :meditate_america
      else
        @splash_style = :default
      end

      @splash_style = :default # Override for now
      @header_style = @splash_style
    end

end

# A workaround that allows you to access a hash using a string, even when the hash is indexed by symbols
# TODO: Re-evaluate if this is necessary
class Hash

  def method_missing name, *args, &blk
    if keys.map(&:to_sym).include? name.to_sym
      self[name.to_sym]
    else
      super
    end
  end

end
