=begin
drop table mc$ma_user;
create table mc$ma_user
(
  id      number(9) primary key,
  department_id   number(9),
  report_user_id  number(9),
  name    varchar2(30),
  phone   varchar2(128),
  cell_phone      varchar2(60),
  email   varchar2(60)
);
insert into mc$ma_user values (1,1,2,'jc',null,null,null); 
insert into mc$ma_user values (2,1,2,'jc2',null,null,null); 
insert into mc$ma_user values (3,1,2,'jc3',null,null,null); 

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

drop table mc$ma_target_user;
create table mc$ma_target_user
(
  id      number(9) primary key,
  user_id     number(9),
  target_id   number(9),
  target_type varchar2(30),
  is_first    number(1) -- boolean
);
 insert into mc$ma_target_user values (1,1,1,'Host',1);
 insert into mc$ma_target_user values (2,1,2,'Host',1);
 insert into mc$ma_target_user values (3,2,1,'Host',0);
insert into mc$ma_target_user values (4,1,1,'Database',1);
insert into mc$ma_target_user values (5,1,3,'Database',1);

=end



require "active_record"
#require 'has_many_polymorphs'

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "100sadmin",
  :username => "strmadmin",
  :password => "strmadmin",
  :host     => "100sadmin"  
)
ActiveRecord::Base.pluralize_table_names = false
ActiveRecord::Base.table_name_prefix = 'mc$ma_'

class TargetUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true
end
class User < ActiveRecord::Base
  has_many :target_users
  has_many :hosts, :through=>:target_users, :source =>:target, :source_type=>'Host'
  has_many :databases, :through=>:target_users, :source =>:target, :source_type=>'Database'
end
class Host < ActiveRecord::Base
  has_many :target_users, :as=>:target 
  has_many :users, :through=>:target_users
  has_one :first_user, :through=>:target_users, :source=>:user, :conditions=>['is_first=?',true]
end
class Database < ActiveRecord::Base
  has_many :target_users, :as=>:target 
  has_many :users, :through=>:target_users
  has_one :first_user, :through=>:target_users, :source=>:user, :conditions=>['is_first=?',true]
end

user1 = User.find(1)
p user1
p user1.target_users
p user1.hosts
p user1.databases

puts "host"
host1 = Host.find(1)
p host1
p host1.target_users
p host1.users
puts "first user"
p host1.first_user
puts "db"
db1 = Database.find(3)
p db1
p db1.target_users
p db1.users
p "ok"
