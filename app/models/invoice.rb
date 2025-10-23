class Invoice < ApplicationRecord
  has_many :invoice_item
  before_save :recalculate_total
  # use after_create to access db id value without making another transaction
  after_create :generate_invoice_number

  # recalculate invoice total by summing invoice items
  # called from invoice_item private method
  def recalculate_total
    new_total = invoice_items.sum { |item| item.quantity * item.price }
    # check for redundant total updates
    return if total == new_total

    # use self.<attribute> within before_save
    # avoids adding more save/update calls into the loop
    # allows the original save call to propogate through fully
    self.total = new_total
  end

  private

  # create human readable invoice number tied to invoice id
  # example: "INV-00001"
  def generate_invoice_number
    # use after_create and self.<attribute> to minimise/avoid callbacks
    self.invoice_number = "INV-#{id.to_s.rjust(5, '0')}"
  end
end
