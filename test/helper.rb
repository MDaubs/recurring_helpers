require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'recurring_helpers'

#Setup defaults otherwise set by Rails
Time.zone = "America/New_York"

#Setup test database
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Schema.define(:version => 1) do
  create_table :events do |t|
    t.string :description
    t.string :summary
    t.datetime :start_at
    t.datetime :end_at
    t.boolean :all_day, :default => false
    t.text :cached_ical
  end
  create_table :event_occurrences do |t|
    t.datetime :start_at
    t.datetime :end_at
    t.integer :event_id
  end
  create_table :event_rules do |t|
    t.integer :count
    t.datetime :until
    t.string :freq
    t.integer :interval
    t.string :wkst
    t.boolean :exclusion
    t.integer :event_id
  end
end
