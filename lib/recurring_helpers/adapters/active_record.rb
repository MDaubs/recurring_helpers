module RecurringHelpers
  module Adapters
    module ActiveRecord
      def is_recurring
        include RecurringHelpers::RecurringModel
      end
    end
  end
end
