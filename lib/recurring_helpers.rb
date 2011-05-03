require 'rails'
require 'tzinfo'
require 'active_support/all'
require 'ri_cal'
require 'active_record'
require 'recurring_helpers/rails'

module RecurringHelpers
  autoload :RecurringModel, 'recurring_helpers/recurring_model'
  autoload :ActiveRecord, 'recurring_helpers/active_record'

end

ActiveRecord::Base.extend RecurringHelpers::ActiveRecord
