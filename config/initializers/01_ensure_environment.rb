unless Rails.env.test?
  %w[
    STRIPE_PUBLISHABLE_KEY
    STRIPE_SECRET_KEY
    STRIPE_MONTHLY_DONATION_PLAN
    STRIPE_ONE_TIME_PAYMENT_PRODUCT
    STRIPE_INVOICE_ENDPOINT_SECRET
  ].each do |env_var|
    if !ENV.key?(env_var) || ENV[env_var].blank?
      raise "Missing environment variable: #{env_var}"
    end
  end
end
