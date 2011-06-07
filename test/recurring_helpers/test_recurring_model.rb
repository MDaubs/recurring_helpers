require 'helper'

class TestRecurringModel < ActiveSupport::TestCase

  class Event < ActiveRecord::Base
    has_many :event_occurrences, :dependent => :destroy
    has_many :event_rules, :dependent => :destroy
    is_recurring
  end

  class EventOccurrence < ActiveRecord::Base
    belongs_to :event
  end

  class EventRule < ActiveRecord::Base
    belongs_to :event
  end

  test 'model generates cached_ical when saved' do
    e             = Event.new
    e.description = "Description of Event"
    e.summary     = "Summary of Event"
    e.start_at    = Time.zone.parse("May 1, 2011 4:00pm")
    e.end_at      = Time.zone.parse("May 1, 2011 5:30pm")
    assert e.cached_ical.nil?
    assert e.save
    assert_equal "BEGIN:VCALENDAR\nPRODID;X-RICAL-TZSOURCE=TZINFO:-//com.denhaven2/NONSGML ri_cal gem//EN\nCALSCALE:GREGORIAN\nVERSION:2.0\nBEGIN:VTIMEZONE\nTZID;X-RICAL-TZSOURCE=TZINFO:America/New_York\nBEGIN:DAYLIGHT\nDTSTART:20110313T020000\nRDATE:20110313T020000\nTZOFFSETFROM:-0500\nTZOFFSETTO:-0400\nTZNAME:EDT\nEND:DAYLIGHT\nEND:VTIMEZONE\nBEGIN:VEVENT\nDTEND;TZID=America/New_York;VALUE=DATE-TIME:20110501T173000\nDTSTART;TZID=America/New_York;VALUE=DATE-TIME:20110501T160000\nDESCRIPTION:Description of Event\nSUMMARY:Summary of Event\nEND:VEVENT\nEND:VCALENDAR\n", e.cached_ical
  end

  test 'model generates exactly one event_occurrence when saved with no rules' do
    start_at = Time.zone.parse("May 2, 2011 4:00pm")
    end_at   = Time.zone.parse("May 2, 2011 5:30pm")
    e             = Event.new
    e.description = "Description of Event"
    e.summary     = "Summary of Event"
    e.start_at    = start_at
    e.end_at      = end_at
    assert e.save
    assert_equal 1, e.event_occurrences.count
    assert_equal start_at, e.event_occurrences.first.start_at
    assert_equal end_at, e.event_occurrences.first.end_at
  end

  test 'model generates many event_occurrences when saved with rules' do
    start_at = Time.zone.parse("May 3, 2011 4:00pm")
    end_at   = Time.zone.parse("May 3, 2011 5:30pm")
    e             = Event.new
    e.description = "Description of Event"
    e.summary     = "Summary of Event"
    e.start_at    = start_at
    e.end_at      = end_at
    e.event_rules.build :freq => "DAILY", :interval => 3, :count => 4
    assert e.save
    assert_equal 4, e.event_occurrences.count
    assert_equal start_at, e.event_occurrences.first.start_at
    assert_equal end_at, e.event_occurrences.first.end_at
    assert_equal start_at + 3.days, e.event_occurrences.second.start_at
    assert_equal end_at + 3.days, e.event_occurrences.second.end_at
  end
end
