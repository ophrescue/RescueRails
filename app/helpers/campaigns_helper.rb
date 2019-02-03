module CampaignsHelper
  def current_campaign_scope
    campaign_scopes[@scope]
  end

  def alternate_campaign_scope_string
    campaign_scopes[alternate_campaign_scope]
  end

  def alternate_campaign_scope
    @scope == "active" ? "inactive" : "active"
  end

  private

  def campaign_scopes
    {"active" => t(".title.active"), "inactive" => t(".title.inactive")}
  end
end
