class Array
  # for example ["Tracking ID", "Foster Location"] becomes:
  # {tracking_id: "Tracking ID", foster_location: "Foster Location"}
  def as_options
    self.inject({}){|hash, string| hash[string.downcase.gsub(/\s/,"_")]=string; hash}
  end

  def to_sentence_period
    return "" if self.empty?
    self.to_sentence + "."
  end
end
