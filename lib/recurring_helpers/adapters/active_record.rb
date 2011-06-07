module RecurringHelpers
  module Adapters
    module ActiveRecord
      def is_recurring
        include RecurringHelpers::Model::Base
      end
    end
  end
end
