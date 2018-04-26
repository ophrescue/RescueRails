require 'rspec/expectations'

RSpec::Matchers.define :be_sorted do |expected|
  match do |actual|
    matches = []
    actual.each_index do |i|
      pair = [actual[i],actual[i.succ]]
      next if pair[1].nil?
      pair = case expected
             when :ascending then pair
             when :descending then pair.reverse
             else raise "unknown sort direction parameter in be_sorted rspec expectation"
             end

      pair = pair.map do |thing|
        # b/c ruby does not compare strings in the same way as sql
        thing.is_a?(String) ? thing.gsub(/\s/,'').downcase : thing
      end

      matches << (pair[1] >= pair[0])
    end
    matches.all?
  end
end
