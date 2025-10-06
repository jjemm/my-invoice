class Invoice < ApplicationRecord
  before_create :generate_invoice_number
  has_many :invoice_item

  # recalculate invoice total by summing invoice items
  # called from invoice_item private method
  def recalculate_total
    new_total = invoice_items.sum { |item| item.quantity * item.unit_price }
    update(total: new_total)
  end

  private

  # create human readable invoice number tied to invoice id
  def generate_invoice_number
    # example: "INV-00001"
    self.invoice_number = format('INV-%d', id.to_s.rjust(5, '0'))
  end
end
