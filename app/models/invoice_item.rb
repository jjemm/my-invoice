class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  after_save :update_invoice_total

  private

  # this is a private call to a function in the invoice model
  def update_invoice_total
    invoice.recalculate_total
  end
end
