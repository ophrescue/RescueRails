require 'rails_helper'

describe RescueRails::BrowserStack do
  let!(:test_class){ Class.new { include RescueRails::BrowserStack } }
  describe "error paths" do
    context "browser not specified" do
      before do
        ENV["BROWSER"] = nil
      end

      it "should should raise exception" do
        expect{test_class.new.capabilities}.to raise_error ArgumentError
        expect{test_class.new.capabilities}.to raise_error "browser must be specified"
      end
    end

    context "browser and version incorrectly specified" do
      before do
        ENV["BROWSER"] = "Internet Explorer 17.0"
      end

      it "should raise error" do
        expect{test_class.new.capabilities}.to raise_error ArgumentError
        expect{test_class.new.capabilities}.to raise_error "format must be browser/version"
      end
    end
  end

  describe "OS inference" do
    context "Internet Explorer specified" do
      before do
        ENV["BROWSER"] = "Internet Explorer/17.0"
      end

      it "should infer Windows/10" do
        expect(test_class.new.capabilities).to include os: "Windows", os_version: "10"
      end
    end

    context "Edge specified" do
      before do
        ENV["BROWSER"] = "Edge/17.0"
      end

      it "should infer Windows/10" do
        expect(test_class.new.capabilities).to include os: "Windows", os_version: "10"
      end
    end

    context "Safari specified" do
      before do
        ENV["BROWSER"] = "Safari/17.0"
      end

      it "should infer OS X/High Sierra" do
        expect(test_class.new.capabilities).to include os: "OS X", os_version: "High Sierra"
      end
    end

    context "Chrome specified" do
      before do
        ENV["BROWSER"] = "Chrome/17.0"
      end

      it "should raise exception" do
        expect{test_class.new.capabilities}.to raise_error ArgumentError
        expect{test_class.new.capabilities}.to raise_error "OS must be specified for Chrome"
      end
    end

    context "Firefox specified" do
      before do
        ENV["BROWSER"] = "Firefox/17.0"
      end

      it "should raise exception" do
        expect{test_class.new.capabilities}.to raise_error ArgumentError
        expect{test_class.new.capabilities}.to raise_error "OS must be specified for Firefox"
      end
    end
  end
end
