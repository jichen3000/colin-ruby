require "openssl"

#plaintext = "1234567890"
#c = OpenSSL::Cipher::Cipher.new("DES")
#c.key = "abcdefghijklmn"
#c.encrypt
#ret = c.update(plaintext)
#p ret << c.final
#
#File.open("d:/eee.txt","w") do |file|
#  file << ret
#end
KEY = "12345678"
encrypt_value = ""
File.open("d:/eee.txt","r") do |file|
  encrypt_value = file.readline
end
p encrypt_value
p encrypt_value.size

p encrypt_value[0..-3]
p encrypt_value[0..-3].size
c = OpenSSL::Cipher::Cipher.new("DES")
c.decrypt
c.key = KEY
#ret = c.update(encrypt_value[0..-3])
ret = c.update(encrypt_value)
p ret
ret << c.final
p ret
p "ok"

#def des_encrypt(plaintext)
#  c = OpenSSL::Cipher::Cipher.new(“DES-CBC”)
#  c.encrypt
#  c.key = KEY
#  c.iv = IV
#  ret = c.update(plaintext)
#  ret << c.final
#end