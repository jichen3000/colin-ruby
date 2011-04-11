#drop sequence mc$dr_role_seq
#create sequence mc$dr_role_seq MINVALUE 100
#create table mc$dr_role(
#id number primary key,
#role varchar2(30),
#enabled varchar2(10)
#)
#
#create table users(
#id number primary key,
#role varchar2(30),
#privs varchar2(30)
#)
#
#create table mc$dr_user_roles_temp(
#user_id number,
#role_id number 
#)
# insert into mc$dr_user_roles_temp (user_id,role_id) values (12955,1);
# insert into mc$dr_user_roles_temp (user_id,role_id) values (12956,2);
# insert into mc$dr_user_roles_temp (user_id,role_id) values (12934,2);
# insert into mc$dr_user_roles_temp (user_id,role_id) values (12934,1);
# insert into mc$dr_user_roles_temp (user_id,role_id) values (12957,3);
# insert into mc$dr_user_roles_temp (user_id,role_id) values (12954,5);
# insert into mc$dr_user_roles_temp (user_id,role_id) values (12957,4);
require "activerecord"

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle",
  :database => "drb",
  :username => "mcdbra",
  :password => "mcdbra",
  :host     => "drb"  
)
#ActiveRecord::Base.pluralize_table_names = false
class User < ActiveRecord::Base
  self.table_name='users'
#  set_primary_key :user_id
  has_and_belongs_to_many :roles, :class_name => "Role", :join_table =>"mc$dr_user_roles_temp",
    :foreign_key => "user_id", :association_foreign_key => "role_id"
end

class Role < ActiveRecord::Base
  self.table_name='mc$dr_role'
#  set_primary_key :sub_id
  has_and_belongs_to_many :users, :class_name => "User", :join_table =>"mc$dr_user_roles_temp", 
    :foreign_key => "role_id", :association_foreign_key => "user_id"  
end

#user = User.find(12934)
#p user
#p user.roles
#role = Role.find(4)
#p role
#p role.users

# insert
# 会进行相关的保存。
# 保存user后，会将role也保存，同时在中间表中生成记录。
user = User.new
user.title = "colin1"
role = Role.new
role.role = "colin"
user.roles << role
user.save