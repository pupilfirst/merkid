class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Mailer

  # default from: 'fullstack@pupilfirst.org'
  # Postmark::ApiInputError (The 'From' address you supplied (fullstack@pupilfirst.org)
  # is not a Sender Signature on your account. Please add and confirm this address in order
  # to be able to use it in the 'From' field of your messages.)
  default from: 'fullstack@pupilfirst.org'
  layout 'mailer'

  protected

  def default_url_options
    { host: Rails.env.production? ? 'fullstack.pupilfirst.org' : 'localhost' }
  end

  def roadie_options
    host_options = default_url_options.merge(protocol: Rails.env.production? ? 'https' : 'http')

    super.merge(url_options: host_options)
  end

  # @param subject [String] subject of the email
  def simple_roadie_mail(subject:)
    roadie_mail(
      {
        subject: subject,
      },
      roadie_options
    )
  end
end

