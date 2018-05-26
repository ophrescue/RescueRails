require 'rails_helper'
require_relative '../helpers/rspec_matchers'

describe DogSearch do
  describe '.search' do
    context 'is a manager' do
      let(:results) { DogSearch.search(params: params) }

      context 'by tracking id' do
        context 'search by tracking_id int' do
          let!(:found_dog) { create(:dog, tracking_id: 1) }
          let!(:other_dog) { create(:dog, tracking_id: 100) }
          let(:params) { { search: '1' } }

          it 'finds the correct dog' do
            expect(results).to include(found_dog)
            expect(results).to_not include(other_dog)
          end
        end

        context 'search by microchip int' do
          let!(:found_dog) do
            create(:dog, name: 'oscar',
                         microchip: '982000000000000',
                         tracking_id: 1)
          end
          let!(:other_dog) do
            create(:dog, name: 'meyer',
                         microchip: 982_000_000_999_999,
                         tracking_id: 11)
          end
          let(:params) { { search: '982000000000000' } }

          it 'finds the correct dog by microchip' do
            expect(results).to include(found_dog)
            expect(results).to_not include(other_dog)
          end
        end
      end

      context 'search by name' do
        let!(:found_dog) { create(:dog, name: 'oscar') }
        let!(:other_dog) { create(:dog, name: 'meyer') }
        let(:params) { { search: 'Oscar' } }

        it 'finds the correct dog by name' do
          expect(results).to include(found_dog)
          expect(results).to_not include(other_dog)
        end
      end

      context 'dogs with similar names' do
        let!(:tt) { create(:dog, name: 'tt', tracking_id: 10) }
        let!(:butter) { create(:dog, name: 'butter', tracking_id: 5) }
        let(:params) { { search: 'tt' } }

        it 'shows dog with name starting with search term first' do
          expect(results).to eq([tt, butter])
        end
      end

      context 'searching for dogs by name with an asc sort' do
        let!(:tt) { create(:dog, name: 'tt') }
        let!(:butter) { create(:dog, name: 'butter') }
        let!(:stutter) { create(:dog, name: 'stutter') }
        let!(:zutter) { create(:dog, name: 'zutter') }
        let!(:frank) { create(:dog, name: 'frank') }
        let(:params) { { search: 'tt', sort: 'name', direction: 'asc' } }

        it 'shows dogs in order by name ascending (a-z)' do
          expect(results).to eq([butter, stutter, tt, zutter])
        end
      end

      context 'searching for dogs by name with a desc sort' do
        let!(:tt) { create(:dog, name: 'tt') }
        let!(:butter) { create(:dog, name: 'butter') }
        let!(:stutter) { create(:dog, name: 'stutter') }
        let!(:zutter) { create(:dog, name: 'zutter') }
        let!(:frank) { create(:dog, name: 'frank') }
        let(:params) { { search: 'tt', sort: 'name', direction: 'desc' } }

        it 'shows dogs in order by name descending (z-a)' do
          expect(results).to eq([zutter, tt, stutter, butter])
        end
      end

      context 'search by microchip string' do
        let!(:found_dog) { create(:dog, name: 'oscar', microchip: 'ABC123') }
        let!(:other_dog) { create(:dog, name: 'meyer') }
        let(:params) { { search: 'ABC123' } }

        it 'finds the correct dog by microchip' do
          expect(results).to include(found_dog)
          expect(results).to_not include(other_dog)
        end
      end

      context 'search by name in q param' do
        let!(:found_dog) { create(:dog, name: 'oscar') }
        let!(:other_dog) { create(:dog, name: 'meyer') }
        let(:params) { { search: 'oscar' } }

        it 'finds the correct dog' do
          expect(results).to include(found_dog)
          expect(results).to_not include(other_dog)
        end
      end

      context 'searching with no params returns no results' do
        let(:params) { {} }

        it 'contains 0 dogs' do
          expect(results).to be_empty
        end
      end
    end

  end
end
