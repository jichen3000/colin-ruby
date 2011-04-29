require 'rsolr'
solr = RSolr.connect :url => 'http://172.16.4.98:8983/solr'

# send a request to /select
re = solr.select({:q =>'DRG-10000',:version=>2.2,:indent=>'on',:start=>0,:rows=>10})
p re
    
p "ok"