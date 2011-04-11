require 'activerecord'
#ActiveRecord连接
ActiveRecord::Base.establish_connection(
  :adapter  => "oci",
  :database => "drb",
  :username => "mcdbra",
  :password => "mcdbra",
  :host     => "drb"
)

class DrConfigStorage < ActiveRecord::Base
  set_table_name "mc$dr_config_storage"
  set_primary_key "subcompoent_id"
  set_sequence_name "users_seq"
end
class DrSubsystemNetwork < ActiveRecord::Base
  set_table_name "mc$dr_system_network"
  set_primary_key "subcompoent_id"
end

dr_cs=DrConfigStorage.new();
dr_cs.storage_type="222";
dr_cs.save;
dr_cs2=DrConfigStorage.find_by_storage_type("222")
dr_sn=DrSubsystemNetwork.new();
dr_sn.subcompoent_id=dr_cs2.subcompoent_id
dr_sn.net_type="222";
dr_sn.save;
