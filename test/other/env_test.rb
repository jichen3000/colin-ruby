ENV.each do |item|
  p item  
end
p $:
p $$ #pid
p ":kkk"
p $LOAD_PATH 
$LOAD_PATH << ENV["HOMEDRIVE"]
p $LOAD_PATH
 $VERBOSE=true
p $VERBOSE
p $SAFE
p $-K
p RUBY_VERSION
p RUBY_PLATFORM
p RUBY_RELEASE_DATE