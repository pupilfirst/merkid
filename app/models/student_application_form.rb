class StudentApplicationForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :email, :first_name, :full_name, :dob, :college, :portfolio,
                :anything_else, :source, :state, :semester, :phone_number,
                :course, :terms_agreed

  validates :first_name, presence: { message: 'Please fill in your first name.' }
  validates :full_name, presence: { message: 'Full name as per official records is mandatory.' }
  validates :dob, presence: { message: 'Date of birth is required.' }
  validates :college, presence: { message: 'College name is required.' }
  validates :source, presence: { message: 'Source is required.' }
  validates :state, presence: { message: 'Please fill in the State where your institution is located.' }
  validates :semester, presence: { message: 'Semester is required.' }
  validates :phone_number, presence: { message: 'Phone number is required.' }
  validates :course, presence: { message: 'Please enter your Course details.' }
  validates :terms_agreed, presence: { message: 'You have to accept the terms to participate in the program.' }
end
