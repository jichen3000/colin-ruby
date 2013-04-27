require 'redis'

records = [{"id"=>"1365342361481", "span"=>"48", "finished"=>"true", "type"=>"studying", "serverDate"=>"1", "clientDate"=>"1365342361488"},
{"id"=>"1365342368098", "span"=>"48", "finished"=>"true", "type"=>"studying", "serverDate"=>"1", "clientDate"=>"1365342368100"},
{"id"=>"1365342369334", "span"=>"30", "finished"=>"true", "type"=>"studying", "serverDate"=>"1", "clientDate"=>"1365342369334"},
{"id"=>"1365342370649", "span"=>"48", "finished"=>"true", "type"=>"studying", "serverDate"=>"1", "clientDate"=>"1365342370650"},
{"id"=>"1365342372424", "span"=>"48", "finished"=>"true", "type"=>"work", "serverDate"=>"1", "clientDate"=>"1365342372424"},
{"id"=>"1365342374006", "span"=>"48", "finished"=>"true", "type"=>"other", "serverDate"=>"1", "clientDate"=>"136 534 2374 007"}]

user = "colin"
table_name = 'clock'
SEQ_NAME = 'seq'

def get_now_millisecond
    (Time.now.to_f * 1000).to_i
end

def transform(redis, table_name, user, seq_name, records)
    def transform_one(redis, table_name, user, seq_name, record)
        record['id'] = redis.incr([table_name,user,seq_name].join('_'))
        record['serverDate'] = get_now_millisecond()
        row_key = [table_name, user, record['id']].join('_')
        record.delete('id')
        record.map {|key, value| [ [row_key, key].join('_'), value]}
    end
    (records.map {|x| transform_one(redis, table_name, user, seq_name, x)}).flatten(1)
end

def save(redis, list)
    list.map{|key, value| redis.set(key, value)}
    
end

redis = Redis.new(:host => "127.0.0.1", :port => 6379)
# clock_colin_id = [table_name,user,SEQ_NAME].join('_')
# print redis.incr(clock_colin_id)
list = transform(redis, table_name, user, SEQ_NAME, records)
save(redis, list)