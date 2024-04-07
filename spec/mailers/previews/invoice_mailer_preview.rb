class InvoiceMailerPreview < ActionMailer::Preview
  def invoice_paid
    @invoice = Invoice.last
    InvoiceMailer.invoice_paid(@invoice.id)
  end

  def contract_added
    @invoice = Invoice.last
    InvoiceMailer.contract_added(@invoice.id)
  end

  def contract_removed
    @invoice = Invoice.last
    InvoiceMailer.contract_removed(@invoice.id)
  end
end
