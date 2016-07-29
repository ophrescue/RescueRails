require 'rails_helper'

describe DogSearcher do
  describe '.search' do
    context 'is a manager' do
      let(:manager) { true }
      let(:results) { DogSearcher.search(params: params, manager: manager) }

      context 'by tracking id' do
        context 'search by tracking_id int' do
          let!(:found_dog) { create(:dog, tracking_id: 1) }
          let!(:other_dog) { create(:dog, tracking_id: 100) }
          let(:params) { { search: 1 } }

          it 'finds the correct dog' do
            expect(results).to include(found_dog)
            expect(results).to_not include(other_dog)
          end
        end

        context 'search by microchip int' do
          let!(:found_dog) do
            create(:dog, name: 'oscar', microchip: 123_456, tracking_id: 1)
          end
          let!(:other_dog) { create(:dog, name: 'meyer', tracking_id: 11) }
          let(:params) { { search: 123_456 } }

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

      context 'search by microchip string' do
        let!(:found_dog) { create(:dog, name: 'oscar', microchip: 'ABC123') }
        let!(:other_dog) { create(:dog, name: 'meyer') }
        let(:params) { { search: 'ABC123' } }

        it 'finds the correct dog by microchip' do
          expect(results).to include(found_dog)
          expect(results).to_not include(other_dog)
        end
      end

      context 'search by active status' do
        let!(:found_dog) { create(:dog, :adoptable) }
        let!(:other_dog) { create(:dog, :completed) }
        let(:params) { { status: 'active' } }

        it 'finds the correct dog' do
          expect(results).to include(found_dog)
          expect(results).to_not include(other_dog)
        end
      end

      context 'search by any status' do
        let!(:found_dog) { create(:dog, :completed) }
        let!(:other_dog) { create(:dog, :adoptable) }
        let(:params) { { status: 'completed' } }

        it 'finds the correct dog' do
          expect(results).to include(found_dog)
          expect(results).to_not include(other_dog)
        end
      end

      context 'search by name in q param' do
        let!(:found_dog) { create(:dog, name: 'oscar') }
        let!(:other_dog) { create(:dog, name: 'meyer') }
        let(:params) { { q: 'oscar' } }

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

    context 'is not a manager' do
      let(:manager) { false }

      let!(:found_dog) { create(:dog, :adoptable) }
      let!(:other_dog) { create(:dog, :completed) }
      let(:params) { {} }
      let(:results) { DogSearcher.search(params: params, manager: manager) }

      it 'finds the correct dog' do
        expect(results).to include(found_dog)
        expect(results).to_not include(other_dog)
      end
    end
  end
end
