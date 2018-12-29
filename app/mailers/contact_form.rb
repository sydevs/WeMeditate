## CONTACT FORM MAILER
# This mailer will send an email to the site admin.
# Intended to be used when someone fills out the contact form.

class ContactForm < MailForm::Base
  attribute :email_address, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message,       validate: true
  attribute :gobbledigook,  captcha: true

  # Declare the e-mail headers. It accepts anything the mail method in ActionMailer accepts.
  def headers
    {
      subject: "Contact from #{email_address}",
      to: ENV['SMTP_EMAIL'],
      from: ENV['SMTP_EMAIL'],
      reply_to: email_address,
    }
  end
end
