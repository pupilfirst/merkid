class ApplicationMailer < ActionMailer::Base
  # default from: 'fullstack@pupilfirst.org'
  # Postmark::ApiInputError (The 'From' address you supplied (fullstack@pupilfirst.org)
  # is not a Sender Signature on your account. Please add and confirm this address in order
  # to be able to use it in the 'From' field of your messages.)
  default from: 'fullstack@pupilfirst.org'
  layout 'mailer'
end
