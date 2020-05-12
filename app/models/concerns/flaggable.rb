module Flaggable
  extend ActiveSupport::Concern

  FILTER_FLAGS = ["Hidden", "High Priority", "Medical Need", "Special Needs", "Medical Review Needed", "Behavior Problems",
    "Foster Needed", "Spay Neuter Needed", "No Cats", "No Dogs", "No Kids", "No Urban Setting", "Home Check Required"].freeze

  included do
    scope :hidden,                               -> { where hidden: true }
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
    scope :no_urban_setting,                     -> { where no_urban_setting: true }
    scope :home_check_required,                  -> { where home_check_required: true }
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
