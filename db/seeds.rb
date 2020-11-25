# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  first_name: "Elodin",
  full_name: "Elodin O'Hara",
  email: "jasim.ab@gmail.com",
  dob: DateTime.parse("1950-01-28"),
  tf_token: "uniq-typform",
  tf_data: {q1: "answer1"},
  status: "unverified"
)
