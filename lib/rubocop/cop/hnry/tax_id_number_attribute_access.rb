# frozen_string_literal: true

module RuboCop
  module Cop
    module Hnry
      # This cop warns about using the tax_id_number attribute on a Financial.
      #
      # Example:
      #
      # financial.tax_id_number
      #

      class TaxIdNumberAttributeAccess < Base
        MSG = "Make sure you understand where tax_id_number can be printed. \nTLDR: NZ - yes, Elsewhere - no. \n\nMore info at https://www.notion.so/hnry/tax_id_number-linting-1fa3aad09f0680f28593ce8ec7d4c281"

        def_node_matcher :tax_id_number_attribute_access?, <<-PATTERN
          ({send csend}
            $...
            :tax_id_number
          )
        PATTERN

        def on_send(node)
          return unless tax_id_number_attribute_access?(node)

          add_offense(node, message: MSG, severity: :warning)
        end
      end
    end
  end
end
