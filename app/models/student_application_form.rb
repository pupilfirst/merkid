class StudentApplicationForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :email, :first_name, :full_name, :dob, :college, :portfolio, :anything_else, :source, :state, :semester, :phone_number, :course

  validates :first_name, presence: { message: 'Please fill in your first name.' }
  validates :full_name, presence: { message: 'Full name as per official records is mandatory.' }
  validates :dob, presence: { message: 'Date of birth is required.' }
  validates :college, presence: { message: 'College name is required.' }
  validates :source, presence: { message: 'Source is required.' }
  validates :state, presence: { message: 'State is required.' }
  validates :semester, presence: { message: 'Semester is required.' }
  validates :phone_number, presence: { message: 'Phone number is required.' }
  validates :course, presence: { message: 'Course is required.' }
end
