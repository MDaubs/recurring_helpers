module RecurringHelpers
  module Model
    module Base
      extend ActiveSupport::Concern

      module InstanceMethods
        def to_rical
          model = self
          @rical_event ||= ::RiCal.Event do
            description model.description
            summary     model.summary
            dtstart     model.start_at
            dtend       model.end_at
            for rule in model.event_rules
              rrule :freq => rule.freq, :interval => rule.interval, :count => rule.count, :until => rule.until, :wkst => rule.wkst
            end
          end
        end
      end

      included do
        before_save do
          self.cached_ical = self.to_rical.export
          self.event_occurrences.clear
          self.to_rical.occurrences.each do |occurrence|
            self.event_occurrences.build :start_at => occurrence.dtstart, :end_at => occurrence.dtend
          end
        end
      end
    end
  end
end
