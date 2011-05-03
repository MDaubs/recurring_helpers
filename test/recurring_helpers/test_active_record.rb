require 'helper'

module RecurringHelpers

  class TestActiveRecord < ActiveSupport::TestCase

    test '#is_recurring includes RecurringHelpers::RecurringModel' do
      class TestClass < ::ActiveRecord::Base
        is_recurring
      end
      assert TestClass.include? RecurringHelpers::RecurringModel
    end

  end

end
