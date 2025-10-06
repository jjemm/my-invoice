class Invoice < ApplicationRecord
  before_create :generate_invoice_number

  private

  # create human readable invoice number tied to invoice id
  def generate_invoice_number
    # example: "INV-00001"
    self.invoice_number = format('INV-%d', id.to_s.rjust(5, '0'))
  end
end
