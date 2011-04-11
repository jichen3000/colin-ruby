require 'cgi'

p CGI::escape("'Stop!' said Fred")
p CGI::unescape("&nbsp")
p CGI::unescapeElement("&nbsp")
p CGI::unescapeHTML("&nbsp")