namespace 'typeform' do
  desc "Poll TypeForm API for new users and add them to db and email them"
  task load_users: :environment do
    user = User.first
    UserMailer.with(user: user).login_email.deliver_later
  end
end
