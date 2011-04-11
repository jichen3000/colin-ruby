require "active_record"
ENV["RAILS_ENV"] = "test"
require File.expand_path("D:/work/workspace/megatrust/megatrust-web/config/environment")
require 'test_help'

require 'database'

class FirstTest < ActiveSupport::TestCase
  test "destroy_first" do
    database = Database.find(:first)
    hash = database.attributes.reject! do |key,value|
      key != "name"
    end
    p database.attributes
    p database.to_json
    p hash.to_json
  end
end