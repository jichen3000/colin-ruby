str = "g fmnc wms bgblr rpylqjyrc gr zw fylb. rfyrq ufyr amknsrcpq ypc dmp. bmgle gr gl zw fylb gq glcddgagclr ylb rfyr'q ufw rfgq rcvr gq qm jmle. sqgle qrpgle.kyicrpylq() gq pcamkkclbcb. lmu ynnjw ml rfc spj. map"
result = ""
url = ""
p "a"[0],"z"[0] 
str.each_byte do |i|
  if i>=97 and i<=122
    if(i+2<="z"[0])
      result += (i+2).chr
      url +=(i+2).chr
    else
      result += (i-24).chr
      url +=(i-24).chr
    end
  else
    result += i.chr
  end
end
p result
puts url
