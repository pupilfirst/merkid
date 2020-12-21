require "administrate/base_dashboard"

class ReviewDashboard < Administrate::BaseDashboard
  include AdministrateExportable::Exporter

  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo.with_options(searchable: true, searchable_fields: %w[full_name email]),
    id: Field::String.with_options(searchable: false, export: false),
    private_notes: Field::Text,
    tests_passing: Field::Number,
    clean_code: Field::Number,
    program_design: Field::Number,
    language_selection: Field::Number,
    portfolio_quality: Field::Number,
    holistic_evaluation: Field::Number,
    created_at: Field::DateTime.with_options(transform_on_export: -> (field) { field.data&.iso8601 }),
    updated_at: Field::DateTime.with_options(transform_on_export: -> (field) { field.data&.iso8601 }),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  user
  holistic_evaluation
  portfolio_quality
  tests_passing
  clean_code
  program_design
  created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  user
  id
  private_notes
  tests_passing
  clean_code
  program_design
  language_selection
  portfolio_quality
  holistic_evaluation
  created_at
  updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  private_notes
  tests_passing
  clean_code
  program_design
  language_selection
  portfolio_quality
  holistic_evaluation
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how reviews are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(review)
  #   "Review ##{review.id}"
  # end
end
