module AboutAnimalHelper
  def some_details(animal)
    @animal = animal
    [animal.name, first_sentence, second_sentence].join(' ')
  end

  private

  def first_sentence
    "#{pronoun} #{caveats.to_sentence_period}" if caveats.any?
  end

  def second_sentence
    "#{@animal.name} is currently being fostered in #{@animal.foster_location}." if @animal.foster_location
  end

  def caveats
    caveats = []
    caveats << "has special needs" if @animal.is_special_needs
    caveats << "is best in a home without dogs" if @animal.no_dogs
    caveats << "is best in a home without cats" if @animal.no_cats
    caveats << "is best in a home without small children" if @animal.no_kids
    caveats << "is not suitable in an apartment, condo or other urban setting" if @animal.no_urban_setting
    caveats
  end

  def not_yet(is_true)
    is_true ? "" : "not yet"
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
