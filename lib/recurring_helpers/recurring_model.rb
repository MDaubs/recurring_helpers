module RecurringHelpers
  module RecurringModel
    extend ActiveSupport::Concern

    included do
      before_save do
        e = self
        c = ::RiCal.Calendar do
          event do
            description e.description
            summary     e.summary
            dtstart     e.start_at
            dtend       e.end_at
            for rule in e.event_rules
              rrule :freq => rule.freq, :interval => rule.interval, :count => rule.count, :until => rule.until, :wkst => rule.wkst
            end
          end
        end
        self.cached_ical = c.events.first.export
        self.event_occurrences.clear
        c.events.first.occurrences.each do |occurrence|
          self.event_occurrences.build :start_at => occurrence.dtstart, :end_at => occurrence.dtend
        end
      end
    end

    module InstanceMethods
    end

    module ClassMethods
    end

  end
end
