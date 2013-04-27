require 'rubygems'
require 'sinatra'
gem 'ruby-openid', '>=2.1.2'
require 'openid'
require 'openid/store/filesystem'
require 'openid/extensions/ax'

helpers do
  def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session,
        OpenID::Store::Filesystem.new("#{File.dirname(__FILE__)}/tmp/openid"))  
  end
 
  def root_url
    request.url.match(/(^.*\/{2}[^\/]*)/)[1]
  end
end
 
 
get '/login' do
  erb :login
end
 
post '/login/openid' do
  openid = params[:openid_identifier]
  begin
    oidreq = openid_consumer.begin(openid)
  rescue OpenID::DiscoveryFailure => why
    p "error:", why
    "Sorry, we couldn't find your identifier #{openid}."
  else
    # ax
    ax_req = OpenID::AX::FetchRequest.new
    ax_req.add(OpenID::AX::AttrInfo.new("http://axschema.org/contact/email", "email", true))
    ax_req.add(OpenID::AX::AttrInfo.new("http://axschema.org/contact/country/home", "country", true))
    ax_req.add(OpenID::AX::AttrInfo.new("http://axschema.org/namePerson/first", "first", true))
    ax_req.add(OpenID::AX::AttrInfo.new("http://axschema.org/namePerson/last", "last", true))
    ax_req.add(OpenID::AX::AttrInfo.new("http://axschema.org/pref/language", "language", true))

    oidreq.add_extension(ax_req)

    redirect oidreq.redirect_url(root_url, root_url + "/login/openid/complete")
  end
end
 
get '/login/openid/complete' do
  oidresp = openid_consumer.complete(params, request.url)
  openid = oidresp.display_identifier
  puts "openid:",oidresp
  case oidresp.status
    when OpenID::Consumer::FAILURE
      "Sorry, we could not authenticate you with this identifier #{openid}."
 
    when OpenID::Consumer::SETUP_NEEDED
      "Immediate request failed - Setup Needed"
 
    when OpenID::Consumer::CANCEL
      "Login cancelled."
 
    when OpenID::Consumer::SUCCESS
      ax_resp = OpenID::AX::FetchResponse.from_success_response(oidresp)
      ax_message = "Simple Registration data was requested"
      ax_message << ". The following data were sent:"
      ax_resp.data.each do |k,v|
        ax_message << "<br/><b>#{k}</b>: #{v}"
      end

      ax_message  # startup something
  end
end
 

 
__END__
 
@@ layout
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
  <title>got openid?</title>
</head>
<body>
  <%= yield %>
</body>
</html>
 
 
@@ login
<form method="post" accept-charset="UTF-8" action='/login/openid'>
  Identifier:
  <input type="text" class="openid" name="openid_identifier" value="www.google.com/accounts/o8/id"/>
  <input type="submit" value="Verify" />
</form>

