class ApplicationController < ActionController::Base

  include ApplicationHelper
  include Regulator
  protect_from_forgery # with: :exception
  before_action :enfore_maintenance_mode, except: %i[maintenance]

  # The root page of the website
  def home
    @record = StaticPage.preload_for(:content).find_by(role: :home)

    # TODO: Deprecated
    @static_page = @record
    @metadata_record = @static_page
  end

  # The page where we embed a map from the program database
  def map
    render layout: 'minimal'
  end

  # A POST endpoint to submit a contact message to the site admins
  def contact
    contact_params = params.fetch(:contact, {}).permit(:email_address, :message, :gobbledigook)

    if not contact_params[:email_address].present?
      @message = I18n.translate('form.missing.email')
      @success = false
    elsif not contact_params[:message].present?
      @message = I18n.translate('form.missing.message')
      @success = false
    else
      contact = ContactForm.new(params[:contact])

      if contact.deliver
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
    if not params[:email_address].present?
      @message = I18n.translate('form.missing.email')
      @success = false
    else
      email = params[:email_address].gsub(/\s/, '').downcase
      email_hash = Digest::MD5.hexdigest(email)

      begin
        Gibbon::Request.new.lists(params[:mailchimp_list_id]).members(email_hash).upsert(
          body: {
            email_address: email,
            status: 'subscribed',
            language: I18n.locale,
            signup: request.referer,
            ip_signup: request.remote_ip,
          }
        )

        @message = I18n.translate('form.success.subscribe')
        @success = true
      rescue Gibbon::MailChimpError => error
        @message = error.detail.to_s
        @success = false
      end
    end
  end

  # The page that users are redirected to if the site is in maintenance mode and they aren't logged in.
  def maintenance
    render layout: 'basic'
  end

  def robots
    render 'application/robots.txt.erb', layout: false, content_type: Mime[:text]
  end

  def error
    render status: request.env['PATH_INFO'][1, 3].to_i
  end

  protected

    def layout_by_resource
      devise_controller? ? 'devise' : 'application'
    end

    # Enforces the maintenance mode redirect
    def enfore_maintenance_mode
      return unless ENV['MAINTENANCE_MODE']
      return if %w[sessions switch_user].include? controller_name
      return if current_user.present?

      redirect_to maintenance_path
    end

    def authorized_preview? model
      return false unless params[:preview] == 'true'
      return true if request.referrer.nil?

      referrer_host = URI.parse(request.referrer).host
      return %w[admin.localhost admin.omicron.local admin.wemeditate.co].include?(referrer_host)
      # Note: Since the admin and front end use different domains, we cannot authenticate across both domains.
      # So we are just using a crude trick to avoid people posting links to the draft.
      # There is no security concern with people viewing a draft.

      # return false unless params[:preview] && current_user
      # policy = Regulator.policy(current_user, model, "Admin::#{model.model_name.plural.camelize}Controller".constantize)
      # @preview = policy.preview?
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
