module AboutDogHelper
  def some_details
    [@dog.name, first_sentence, second_sentence, third_sentence].join(' ')
  end

  private

  def first_sentence
    [up_to_date_on_shots, spay_or_neuter_status].to_sentence_period
  end

  def second_sentence
    "#{pronoun} #{caveats.to_sentence_period}" if caveats.any?
  end

  def third_sentence
    "#{@dog.name} is currently being fostered in #{@dog.foster_location}." if @dog.foster_location
  end

  def caveats
    caveats = []
    caveats << "is a special needs dog" if @dog.is_special_needs
    caveats << "is not good with other dogs" if @dog.no_dogs
    caveats << "is not good with cats" if @dog.no_cats
    caveats << "is not good for homes with small children" if @dog.no_kids
    caveats
  end

  def spay_or_neuter_status
    not_yet = not_yet(@dog.is_altered)
    "has #{not_yet} been #{spayed_or_neutered}"
  end

  def up_to_date_on_shots
    not_yet = not_yet(@dog.is_uptodateonshots)
    "is #{not_yet} up-to-date on #{posessive_pronoun} shots"
  end

  def not_yet(is_true)
    is_true ? "" : "not yet"
  end

  def spayed_or_neutered
    @dog.gender == "Male" ? "neutered" : "spayed"
  end

  def posessive_pronoun
    male? ? "his" : "her"
  end

  def pronoun
    male? ? "He" : "She"
  end

  def male?
    @dog.gender == "Male"
  end
end
