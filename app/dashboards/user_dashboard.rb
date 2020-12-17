require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    task_submissions: Field::HasMany,
    id: Field::String.with_options(searchable: false),
    first_name: Field::String,
    full_name: Field::String,
    email: Field::String,
    dob: Field::Date,
    application_form: Field::String.with_options(searchable: false),
    status: Field::String,
    task_revealed_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    college: Field::Text,
    portfolio: Field::Text,
    anything_else: Field::Text,
    source: Field::Text,
    state: Field::String,
    phone_number: Field::String,
    semester: Field::String,
    course: Field::String,
    terms_agreed_at: Field::DateTime,
    discarded_at: Field::DateTime,
    task_submitted_at: Field::DateTime,
    submission_receipt_emailed_at: Field::DateTime,
    task_reviewed_at: Field::DateTime,
    task_review_message: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  full_name
  email
  status
  task_submissions
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  task_submissions
  id
  first_name
  full_name
  email
  dob
  application_form
  status
  task_revealed_at
  created_at
  updated_at
  college
  portfolio
  anything_else
  source
  state
  phone_number
  semester
  course
  terms_agreed_at
  discarded_at
  task_submitted_at
  submission_receipt_emailed_at
  task_reviewed_at
  task_review_message
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  first_name
  full_name
  email
  dob
  application_form
  status
  task_revealed_at
  college
  portfolio
  anything_else
  source
  state
  phone_number
  semester
  course
  discarded_at
  task_submitted_at
  task_reviewed_at
  task_review_message
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  COLLECTION_FILTERS = {
    email_unverified: ->(users) { users.where(status: User::EMAIL_UNVERIFIED) },
    email_verified: ->(users) { users.where(status: User::EMAIL_VERIFIED) },
    application_form_submitted: ->(users) { users.where(status: User::APPLICATION_FORM_SUBMITTED) },
    task_revealed: ->(users) { users.where(status: User::TASK_REVEALED) },
    task_submitted: ->(users) { users.where(status: User::TASK_SUBMITTED) },
    task_reviewed: ->(users) { users.where(status: User::TASK_REVIEWED) },
  }.freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  def display_resource(user)
    "#{user.full_name} <#{user.email}>"
  end
end
