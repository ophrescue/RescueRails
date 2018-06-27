require 'rspec/expectations'

RSpec::Matchers.define :be_sorted do |expected|
  match do |actual|
    return false if actual.length.zero?
    matches = []
    actual.each_index do |i|
      pair = [actual[i],actual[i.succ]]
      next if pair[1].nil?
      pair = case expected
             when :ascending then pair
             when :descending then pair.reverse
             else raise "unknown sort direction parameter in be_sorted rspec expectation"
             end

      matches << (pair[1] >= pair[0])
    end
    matches.all?
  end
end

RSpec::Matchers.define :have_check_icon do
  match do |actual|
    actual.has_css? '.fa-check'
  end
end

RSpec::Matchers.define :have_x_icon do
  match do |actual|
    actual.has_css? '.fa-times'
  end
end
