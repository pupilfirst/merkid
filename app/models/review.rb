class Review < ApplicationRecord
  belongs_to :user
  validates :tests_passing, inclusion: 0..2
  validates :clean_code, inclusion: 0..2
  validates :program_design, inclusion: 0..2
  validates :language_selection, inclusion: 0..2
  validates :portfolio_quality, inclusion: 0..2
  validates :holistic_evaluation, inclusion: 0..2
end
