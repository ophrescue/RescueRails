require "rails_helper"

describe "routes for Events" do
  it "routes /events to the events controller index action" do
    expect(get("/events")).to route_to("events#index")
  end

  it "routes /events/past to the events controller index action, with past scope" do
    expect(get("/events/past")).to route_to("events#index", scope: 'past')
  end

  it "routes /events/upcoming to the events controller index action, with upcoming scope" do
    expect(get("/events/upcoming")).to route_to("events#index", scope: 'upcoming')
  end

  it "routes /events/:id to the events controller show action" do
    expect(get("/events/555")).to route_to("events#show", id: '555')
  end

  it "routes /events/x to events controller show action if x is not 'upcoming' or 'past'" do
    expect(get("/events/hack_me_if_you_can")).to route_to("events#show", id: "hack_me_if_you_can")
  end
end
