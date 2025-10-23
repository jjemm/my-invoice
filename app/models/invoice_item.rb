class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  after_save :update_invoice_total

  private

  def update_invoice_total
    invoice.save
  end
end
