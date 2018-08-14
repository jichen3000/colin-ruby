require "json"
require "./hash_helper"
def get_conf_hash(default_json_path, personal_json_path)
    default_conf = JSON.parse(File.read(default_json_path))
    if File.exist?(personal_json_path)
        personal_conf = JSON.parse(File.read(personal_json_path))
        default_conf.merge(personal_conf)
    else
        return default_conf
    end
end

def get_conf_hash_deeply(default_json_path, personal_json_path)
    default_conf = JSON.parse(File.read(default_json_path))
    if File.exist?(personal_json_path)
        personal_conf = JSON.parse(File.read(personal_json_path))
        default_conf.deep_merge(personal_conf)
    else
        return default_conf
    end
end
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "get_conf_hash" do
            get_conf_hash("default_conf.json", "personal_conf.json").must_equal(
                {   "ip"=>"123.123.123.123", 
                    "username"=>"admin", 
                    "1"=>{"a"=>"2", "c"=>3}, 
                    "timeout"=>10})
        end
        it "deep_merge" do
            get_conf_hash_deeply("default_conf.json", "personal_conf.json").must_equal(
                {   "ip"=>"123.123.123.123", 
                    "username"=>"admin", 
                    "1"=>{"a"=>"2", "b"=>2, "c"=>3}, 
                    "timeout"=>10})        
            end
    end
end