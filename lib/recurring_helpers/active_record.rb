module RecurringHelpers
  module ActiveRecord

    def is_recurring
      include RecurringHelpers::RecurringModel
    end

  end

end
