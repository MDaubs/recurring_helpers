require 'rails'
require 'tzinfo'
require 'active_support/all'
require 'ri_cal'
require 'active_record'
require 'recurring_helpers/rails'

module RecurringHelpers
  module Model
    autoload :Base, 'recurring_helpers/model/base'
  end
  #autoload :RecurringModel, 'recurring_helpers/recurring_model'
  module Adapters
    autoload :ActiveRecord, 'recurring_helpers/adapters/active_record'
  end
end

ActiveRecord::Base.extend RecurringHelpers::Adapters::ActiveRecord if ActiveRecord
