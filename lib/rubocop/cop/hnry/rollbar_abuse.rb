# frozen_string_literal: true

module RuboCop
  module Cop
    module Hnry
      # We are trying to reduce/remove our dependence on Rollbar because we
      # should be using Datadog instead.
      #
      # @example
      #   # bad
      #   Rollbar.error("an important thing happened")
      #
      #   # good
      #   Rails.logger.error("an important thing happened")

      class RollbarAbuse < Base
        MSG = "Use of Rollbar is DEPRECATED. Please use standard Rails.logger.* instead. This will be captured in Datadog automatically. You can add a Datadog monitor if alerting is important."

        def_node_matcher :rollbar?, <<~PATTERN
          (send (const _ :Rollbar) ...)
        PATTERN

        def on_send(node)
          return unless rollbar?(node)

          add_offense(node, message: MSG, severity: :warning)
        end
      end
    end
  end
end
