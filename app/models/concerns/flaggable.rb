module Flaggable
  extend ActiveSupport::Concern

  FILTER_FLAGS = ["High Priority", "Medical Need", "Special Needs", "Medical Review Needed", "Behavior Problems",
    "Foster Needed", "Spay Neuter Needed", "No Cats", "No Dogs", "No Kids"].freeze

  included do
    scope :high_priority,                        -> { where is_high_priority: true }
    scope :medical_need,                         -> { where has_medical_need: true }
    scope :medical_review_needed,                -> { where medical_review_complete: false }
    scope :special_needs,                        -> { where is_special_needs: true }
    scope :behavior_problems,                    -> { where has_behavior_problem: true }
    scope :foster_needed,                        -> { where needs_foster: true }
    scope :spay_neuter_needed,                   -> { where is_altered: false }
    scope :no_cats,                              -> { where no_cats: true }
    scope :no_dogs,                              -> { where no_dogs: true }
    scope :no_kids,                              -> { where no_kids: true }
  end

  class_methods do
    def has_flags(flags) # flags is an array of active (i.e submitted by user for filter) flag attributes
      filter_flags = Flaggable::FILTER_FLAGS.as_options.keys
      # security measure, ensure received flags are in the list of FILTER_FLAGS
      (filter_flags & flags).inject(unscoped) do |result, filter_flag|
        result.send(filter_flag)
      end
    end
  end
end
