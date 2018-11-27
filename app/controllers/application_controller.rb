class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Regulator
  protect_from_forgery #with: :exception
  before_action :check_maintenance_mode, except: [:maintenance]

  def front
    @static_page = StaticPage.includes(:sections).find_by(role: :home)
    @metatags = @static_page.get_metatags
  end

  def contact
    puts params.inspect
    contact_params = params.fetch(:contact, {}).permit(:email_address, :message, :gobbledigook)

    if not contact_params[:email_address].present?
      @message = 'You must provide an email address.'
      @success = false
    elsif not contact_params[:message].present?
      @message = 'You forgot to fill out a message.'
      @success = false
    else
      contact = ContactForm.new(params[:contact])

      if contact.deliver
        @message = 'Your message has been received.'
        @success = true
      else
        @message = contact.errors.full_messages.join(', ')
        @success = true
      end
    end
  end

  def subscribe
    if not params[:email_address].present?
      @message = 'You must provide an email address.'
      @success = false
    else
      email = params[:email_address].gsub(/\s/, '').downcase
      email_hash = Digest::MD5.hexdigest(email)

      begin
        Gibbon::Request.new.lists(params[:mailchimp_list_id]).members(email_hash).upsert(body: {
          email_address: email,
          status: 'subscribed',
          language: I18n.locale,
          signup: request.referer,
          ip_signup: request.remote_ip,
        })

        @message = 'You have been subscribed.'
        @success = true
      rescue Gibbon::MailChimpError => error
        @message = "#{error.detail}"
        @success = false
      end
    end
  end

  def maintenance
    render layout: 'basic'
  end

  protected
    def layout_by_resource
      if devise_controller?
        'devise'
      else
        'application'
      end
    end

    def check_maintenance_mode
      if ENV['MAINTENANCE_MODE'] and controller_name != 'sessions' and controller_name != 'switch_user' and !current_user.present?
        redirect_to '/maintenance'
      end
    end
end

class Hash
  def method_missing(name, *args, &blk)
    if self.keys.map(&:to_sym).include? name.to_sym
      return self[name.to_sym]
    else
      super
    end
  end
end
