require 'ciphersaber'
class String
  def barr2str16
    len = 2*self.length
    self.unpack('H'+(len).to_s).join.upcase
  end
  def str2barr(str)
    arr = Array.new
    (str.size/2).times do |index|
      arr << str[2*index..(2*index+1)]
    end
    arr.pack("H2"*(arr.size))
  end
end

str = "123456"
shuffle=20 
passwd='mogemoge'
encrypted_text=barr2str16(str.cs_crypt(passwd,shuffle))
aa = str2barr(encrypted_text)
text = aa.cs_decrypt(passwd,shuffle)
puts encrypted_text
puts aa
puts "text:#{text}"
puts "ok"