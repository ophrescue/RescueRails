require 'rails_helper'


#  SHELTERS = {MD: '80736',
#              PA: '84558',
#              VA: '79954'}
#
#  BASE_URL = "http://www.adoptapet.com/shelter{shelter_id}-dogs.html"

describe Adoptapet do
  let(:adoptapet){ Adoptapet.new(dog_foster_region) }

  context "dog does not have a foster" do
    let(:dog_foster_region){ nil }

    it "should return non-html string for #to_s" do
      expect(adoptapet.to_s).to eq "Foster needed for Adoptapet"
    end
  end

  context "dog has a foster" do
    context "foster region is not in the covered area" do
      let(:dog_foster_region){ 'CA' }

      it "should return non-html string for #to_s" do
        expect(adoptapet.to_s).to eq "Adoptapet N/A for CA"
      end
    end

    context "foster region is within the covered area" do
      let(:dog_foster_region){ 'MD' }

      it "should have well-formed url property" do
        expect(adoptapet.url).to eq "http://www.adoptapet.com/shelter80736-dogs.html"
      end

      it "should return html link for #to_s" do
        expect(adoptapet.to_s).to eq "<a href=\"#{adoptapet.url}\">Adoptapet #{adoptapet.region}</a>"
      end
    end
  end
end
