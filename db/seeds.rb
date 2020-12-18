# frozen_string_literal: true

require 'faker'
require 'fileutils'
require 'zip'

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

def make_zip_file_for_attachment(text)
  directory = Pathname.new("/tmp/merkid-test-attachment")
  Dir.mkdir(directory, 0700) rescue nil
  File.open(directory.join("README"), "wt") do |f|
    f.write("Test attachment README. #{text}")
  end
  input_filenames = ['README']
  zipfile_name = "/tmp/merkid-test-attachment.zip"
  File.unlink(zipfile_name) rescue nil
  Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
    input_filenames.each do |filename|
      # Two arguments:
      # - The name of the file as it will appear in the archive
      # - The original file, including the path to find it
      zipfile.add(filename, File.join(directory, filename))
    end
    zipfile.get_output_stream("myFile") { |f| f.write "myFile contains just this" }
  end
  zipfile_name
end

if Rails.env.development?
  statuses = [User::EMAIL_UNVERIFIED, User::EMAIL_VERIFIED, User::APPLICATION_FORM_SUBMITTED, User::TASK_REVEALED, User::TASK_SUBMITTED]
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
    if status == User::APPLICATION_FORM_SUBMITTED || status == User::TASK_REVEALED || status == User::TASK_SUBMITTED
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

    u = User.create!(h)

    if status == User::TASK_SUBMITTED
      zipfile_name = make_zip_file_for_attachment("#{u.id} -- #{u.full_name}")
      task_submission = u.task_submissions.create!
      task_submission.uploaded_file.attach(io: File.open(zipfile_name), filename: 'test-attachment.zip')
    end
  end
end

nil
