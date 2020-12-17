# frozen_string_literal: true

require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.exists?(email: 'jasim@protoship.io')
  User.create!(
    first_name: 'Jasim',
    full_name: 'Jasim A Basheer',
    email: 'jasim@protoship.io',
    dob: DateTime.parse('1950-01-28'),
    status: 'email_verified'
  )
end

if Rails.env.development?
  statuses = [User::EMAIL_UNVERIFIED, User::EMAIL_VERIFIED, User::APPLICATION_FORM_SUBMITTED, User::TASK_REVEALED]
  300.times do |_x|
    name = Faker::Name.name
    i = rand(statuses.length)
    status = statuses[i]
    h = {
      first_name: name.split(' ').first,
      full_name: name,
      email: Faker::Internet.email,
      dob: Faker::Date.between(from: '1995-02-23', to: '2010-09-25'),
      status: status
    }
    if status == User::APPLICATION_FORM_SUBMITTED || status == User::TASK_REVEALED
      h = h.merge(
        college: Faker::Educator.university,
        portfolio: Faker::Company.bs,
        anything_else: Faker::Company.catch_phrase + '. ' + Faker::GreekPhilosophers.quote,
        source: %w[Facebook WhatsApp College Friends Other][rand(5)],
        state: Faker::Address.state,
        phone_number: Faker::PhoneNumber.phone_number,
        semester: rand(1..7),
        course: Faker::Educator.course,
        terms_agreed_at: Faker::Time.between(from: 6.days.ago, to: 1.day.ago),
        updated_at: Faker::Time.between(from: 5.days.ago, to: 1.day.ago),
        created_at: Faker::Time.between(from: 10.days.ago, to: 6.days.ago)
      )
    end
    if status == User::TASK_REVEALED
      h = h.merge(
        task_revealed_at: Faker::Time.between(from: 5.days.ago, to: 1.day.ago)
      )
    end
    User.create!(h)
  end
end
