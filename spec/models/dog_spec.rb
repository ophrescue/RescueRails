require 'spec_helper'

describe Dog do
  describe '#update_adoption_date' do
    let(:dog) { create(:dog, :adoptable) }

    context 'status did not change' do
      it 'does not update the date' do
        old_date = dog.adoption_date
        dog.update_attribute(:name, "new_#{dog.name}")
        expect(dog.adoption_date).to eq(old_date)
      end
    end

    context 'status changed to completed' do
      it 'does not update the date' do
        old_date = dog.adoption_date
        dog.update_attribute(:status, 'completed')
        expect(dog.adoption_date).to eq(old_date)
      end
    end

    context 'status changed to adopted' do
      it 'updates the date' do
        old_date = dog.adoption_date
        dog.update_attribute(:status, 'adopted')
        expect(dog.adoption_date).to eq(Date.today())
      end
    end

    context 'status changed to value that is not complete or adopted' do
      it 'updates the date to nil' do
        dog.update_attribute(:status, 'adopted')
        expect(dog.adoption_date).to be

        dog.update_attribute(:status, 'adoptable')
        expect(dog.adoption_date).to be_nil
      end
    end
  end
end
