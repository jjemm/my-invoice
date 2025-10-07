# frozen_string_literal: true

module RuboCop
  module Cop
    module Hnry
      # UseCases have their own special place in the folder structure, we should use it!
      #
      # @example
      #   # bad
      #   # file: app/services/excellent_feature.rb
      #   include UseCase
      #
      #   # good
      #   # file: app/use_cases/excellent_feature.rb
      #   include UseCase

      class ConfusedUseCase < Base
        MSG = "Did you mean to define your UseCase in the app/services folder? Perhaps it would be better located in app/use_cases :)"

        def_node_matcher :confused_use_case?, <<~PATTERN
          (send _ :include
            (const _ :UseCase))
        PATTERN

        def on_send(node)
          return unless confused_use_case?(node)

          add_offense(node, message: MSG, severity: :warning)
        end
      end
    end
  end
end
