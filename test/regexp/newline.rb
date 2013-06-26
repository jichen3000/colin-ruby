if __FILE__ == $0
    str = <<EOF
events
  doorClosed  D1CL
  drawOpened  D2OP
end
EOF
    # notice \A is different with ^.
    p str
    # whitespace_re = Regexp.new("(^\\s)+")
    whitespace_re = /^(\s)+/
    # identifier_re = Regexp.new("^(\\w)+")
    identifier_re =  /^(\w)+/
    end_re =  /\Aend/
    events_re = /^events/
    end_re.match(str)
    p $&,$'
    str = $'
    # events_re.match(str)
    # p $&,$'
    # str = $'
    # whitespace_re.match(str)
    # p 'whitespace_re :',$&,$'
    # str = $'
    # identifier_re.match(str)
    # p 'identifier_re :',$&,$'
    # str = $'
    puts "ok"
end