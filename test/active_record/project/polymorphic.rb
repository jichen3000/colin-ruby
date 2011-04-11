=begin

drop table mc$ma_host;
create table mc$ma_host
(
  id        number(9) primary key,
  monitor_package_id    number(9),
  hostname  varchar2(128),
  address   varchar2(60),   --ip
  mac       varchar2(60),
  host_type varchar2(60),   --主机类型（询问）
  username  varchar2(60),
  password  varchar2(128),
  os        varchar2(30),
  version   varchar2(30)
);
insert into mc$ma_host (id,hostname) values(1,'mchost1');
insert into mc$ma_host (id,hostname) values(2,'mchost2');
insert into mc$ma_host (id,hostname) values(3,'mchost3');

--数据库
drop table mc$ma_database;
create table mc$ma_database
(
  id        number(9) primary key,
  host_id   number(9),
  monitor_package_id    number(9),
  dbid      varchar2(64),
  dbname    varchar2(128),
  service   varchar2(64),
  username  varchar2(60),
  password  varchar2(128),
  database_home        varchar2(512),
  version   varchar2(30)
);

insert into mc$ma_database (id,dbname) values(1,'db1');
insert into mc$ma_database (id,dbname) values(2,'db2');
insert into mc$ma_database (id,dbname) values(3,'db3');

--监控文件
drop table mc$ma_observation_config;
create table mc$ma_observation_config
(
  id        number(9) primary key,
  name      varchar2(30),
  target_type     varchar2(30), --HOST,DATABASE
  target_id number(9), --根据target_type确定
  file_path varchar2(256),
  rate      number(9,3)  --采样频率，秒
);
insert into mc$ma_observation_config values(1,'f1');
=end



require "active_record"

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "100sadmin",
  :username => "strmadmin",
  :password => "strmadmin",
  :host     => "100sadmin"  
)
ActiveRecord::Base.pluralize_table_names = false
ActiveRecord::Base.table_name_prefix = 'mc$ma_'

class Host < ActiveRecord::Base
  has_many :observation_configs, :as=>:target
end
class Database < ActiveRecord::Base
  has_many :observation_configs, :as=>:target
end

class ObservationConfig < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
end


puts "host"
host1 = Host.find(1)
p host1
puts "db"
db1 = Database.find(3)
p db1
p db1.observation_configs
#oc = ObservationConfig.new
#oc.id = 3
#oc.name = 'oc3'
#oc.target = db1
#oc.save!
#p oc
p "ok"
