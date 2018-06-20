#    Copyright 2017 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

module Filterable
  extend ActiveSupport::Concern

  included do
    scope :is_age,    ->(age) { where age: age }
    scope :is_size,   ->(size) { where size: size }
    scope :is_status, ->(status) { where status: status }
  end

  module ClassMethods
    def filter(filtering_params)
      results = self.unscoped # to be sure an ActiveRecord::Relation is returned, even with no filtering_params
      # [ "is_age", "is_size", "is_status", "has_flags"]
      filtering_params.each do |key, values|
        if values.present?
          results = results.public_send(key, lookup(key,values))
        end
      end
      results
    end

    private
    def lookup(key,values)
      return values if ["training_team",
                        "newsletter",
                        "public_relations",
                        "fundraising",
                        "translator",
                        "active_volunteer"].include? key

      lookup_table = case key.to_sym
                     when :is_age
                       Dog::AGES
                     when :is_size
                       Dog::SIZES
                     when :is_status
                       Dog::STATUSES
                     when :has_flags
                       Dog::FILTER_FLAGS
                     end
      map_keys(lookup_table,values)
    end

    def map_keys(lookup_table,values)
      lookup_table.as_options.slice(*values).values
    end
  end
end
