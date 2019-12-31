module AboutAnimalHelper
  def some_details(animal)
    @animal = animal
    [animal.name, first_sentence, second_sentence, third_sentence].join(' ')
  end

  private

  def first_sentence
    [up_to_date_on_shots, spay_or_neuter_status].to_sentence_period
  end

  def second_sentence
    "#{pronoun} #{caveats.to_sentence_period}" if caveats.any?
  end

  def third_sentence
    "#{@animal.name} is currently being fostered in #{@animal.foster_location}." if @animal.foster_location
  end

  def caveats
    caveats = []
    caveats << "has special needs" if @animal.is_special_needs
    caveats << "is best in a home without dogs" if @animal.no_dogs
    caveats << "is best in a home without cats" if @animal.no_cats
    caveats << "is best in a home without small children" if @animal.no_kids
    caveats
  end

  def spay_or_neuter_status
    not_yet = not_yet(@animal.is_altered)
    "has #{not_yet} been #{spayed_or_neutered}"
  end

  def up_to_date_on_shots
    not_yet = not_yet(@animal.is_uptodateonshots)
    "is #{not_yet} up-to-date on #{posessive_pronoun} shots"
  end

  def not_yet(is_true)
    is_true ? "" : "not yet"
  end

  def spayed_or_neutered
    @animal.gender == "Male" ? "neutered" : "spayed"
  end

  def posessive_pronoun
    male? ? "his" : "her"
  end

  def pronoun
    male? ? "He" : "She"
  end

  def male?
    @animal.gender == "Male"
  end
end
