module RuboCop
  module Cop
    module Migration
      # Methods that raise exceptions in migrations can cause problems when
      # deploying to remote distributed systems.
      #
      # @example
      #   # bad
      #   model.update!(field: "value")
      #
      #   # good
      #   unless model.update(field: "value")
      #     # handle bad case
      #   end
      #
      #   begin
      #     model.update!(field: "value")
      #   rescue
      #     # handle bad case
      #   end
      class DangerousMethod < Base
        MSG = "Beware of methods that can raise exceptions in a migration.".freeze

        ALLOWED_METHODS = [
          :disable_ddl_transaction!
        ].freeze

        def on_send(node)
          on_send_variants(node)
        end

        def on_csend(node)
          on_send_variants(node)
        end

        private

        def on_send_variants(node)
          return if rescued_dangerous_method?(node)
          return if allowed_bang_method?(node.method_name)
          return unless dangerous_method?(node.method_name)

          add_offense(node, severity: :warning)
        end

        def allowed_bang_method?(method_name)
          ALLOWED_METHODS.include?(method_name)
        end

        def dangerous_method?(method_name)
          method_name.to_s.end_with?("!")
        end

        def rescued_dangerous_method?(node)
          dangerous_method?(node.method_name) && parent_is_rescue?(node)
        end

        # Recursively look up through parent nodes until a 'rescue' node, or at the top
        # This is not perfect as the rescue could be for a specfic unrelated exception
        def parent_is_rescue?(node)
          parent = node.parent
          return true if parent && (parent.type == :rescue || parent_is_rescue?(parent))

          false # at the top!
        end
      end
    end
  end
end
