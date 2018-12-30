class CitiesController < ApplicationController

  def index
    @static_page = StaticPage.includes_content.find_by(role: :world)
    @metatags = @static_page.get_metatags
    @countries = City.distinct.pluck(:country)
    @cities = City.with_translations(I18n.locale).select(:name, :country, :slug)
  end

  def local
    redirect_to cities_path
  end

  def country
    @static_page = StaticPage.includes_content.find_by(role: :country)
    @metatags = @static_page.get_metatags
    @breadcrumbs = [
      { name: City.model_name.human(count: -1), url: cities_path },
      { name: I18nData.countries(I18n.locale)[params[:country_code].upcase] }
    ]
  end

  def show
    @static_page = StaticPage.includes_content.find_by(role: :city)
    @city = City.includes_content.friendly.find(params[:id])
    @metatags = @city.get_metatags(@static_page)
    @breadcrumbs = [
      { name: City.model_name.human(count: -1), url: cities_path },
      { name: I18nData.countries(I18n.locale)[@city.country], url: country_path(country_code: @city.country) },
      { name: @city.name }
    ]
  end

  def register
    if not params[:email_address].present?
      @message = I18n.translate('form.missing.email')
      @success = false
    elsif not params[:name].present?
      @message = I18n.translate('form.missing.name')
      @success = false
    else
      city = City.friendly.find(params[:id])
      email = params[:email_address].gsub(/\s/, '').downcase
      email_hash = Digest::MD5.hexdigest(email)
      name = params[:name].rpartition(' ')

      begin
        Gibbon::Request.new.lists(params[:mailchimp_list_id]).members(email_hash).upsert({
          body: {
            email_address: email,
            status: 'subscribed',
            language: I18n.locale,
            signup: request.referer,
            location: {
              latitude: city.latitude,
              longitude: city.longitude,
            },
            ip_signup: request.remote_ip,
            merge_fields: {
              FNAME: name.first,
              LNAME: name.count > 1 ? name.last : '',
            },
          },
        })

        @message = I18n.translate('form.success.register')
        @success = true
      rescue Gibbon::MailChimpError => error
        @message = "#{error.title} - #{error.detail}"
        @success = false
      end
    end
  end

end
