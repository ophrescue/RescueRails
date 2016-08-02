class PagesController < ApplicationController
  before_action :authenticate, only: [:status_definitions]

  def status_definitions
    @hide_topbar = true
  end

  def dog_status_definitions
    @hide_topbar = true
  end
end
