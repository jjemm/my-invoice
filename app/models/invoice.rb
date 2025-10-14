class Invoice < ApplicationRecord
  # use after_create to access db id value without making another transaction
  after_create :generate_invoice_number

  private

  # create human readable invoice number tied to invoice id
  # example: "INV-00001"
  def generate_invoice_number
    # use before_create and self.<attribute> to minimise/avoid callbacks
    self.invoice_number = "INV-#{id.to_s.rjust(5, '0')}"
  end
end
