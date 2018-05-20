class Array
  def to_id_and_value_hash
    self.inject({}){|hash, string| hash[string.downcase.gsub(/\s/,"_")]=string; hash}
  end
end
