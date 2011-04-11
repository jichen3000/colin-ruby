require "openssl"
#doc see http://www.ruby-doc.org/stdlib/libdoc/openssl/rdoc/index.html

class Encrypt
  KEY = "a secret message"
  IV = "aaaavvvv"
  def des_encrypt(plaintext)
    c = OpenSSL::Cipher::Cipher.new("DES")
    c.encrypt
    c.key = KEY
#    c.iv = IV
    ret = c.update(plaintext)
    ret << c.final
  end
  
  def des_decrypt(encrypt_value)
    c = OpenSSL::Cipher::Cipher.new("DES")
    c.decrypt
    c.key = KEY
#    c.iv = IV
    ret = c.update(encrypt_value)
    ret << c.final
  end
  
  def get_rsa_key
    rsa = OpenSSL::PKey::RSA.new(1024)
    # public_key only can public_encrypt or public_decrypt no private_encrypt nor private_decrypt
    #rsa.public_key.to_pem the class of return value is String
    [rsa.public_key.to_pem , rsa.to_pem]
  end
  
  def rsa_private_encrypt(value , rsakey)
    rsa = OpenSSL::PKey::RSA.new(rsakey)
    rsa.private_encrypt(value)
  end
  
  def rsa_private_decrypt(value , rsakey)
    rsa = OpenSSL::PKey::RSA.new(rsakey)
    rsa.private_decrypt(value)
  end
  
  def rsa_public_encrypt(value , publickey)
    rsa = OpenSSL::PKey::RSA.new(publickey)
    rsa.public_encrypt(value)
  end
  
  def rsa_public_decrypt(value , publickey)
    rsa = OpenSSL::PKey::RSA.new(publickey)
    rsa.public_decrypt(value)
  end
end

def testrun
  e = Encrypt.new
  text = "a secret message"
  puts "text:#{text}"
#  value = e.des_encrypt(text)
#  File.open("c:\\1.txt","w") do |f|
#    f.puts value
#  end
#  puts "des_encrypt:#{value}"
#  des_decrypt = e.des_decrypt(value)
#  puts "des_decrypt:#{des_decrypt}"
  
  puts "-------------------------"
  publickey , privatekey = e.get_rsa_key
  puts "publickey:\n#{publickey} \n privatekey=\n#{privatekey}"
  
  value1 = e.rsa_private_encrypt(text , privatekey)
  puts "rsa_private_encrypt:#{value1}"
  rsa_public_decrypt = e.rsa_public_decrypt(value1 , publickey)
  puts "rsa_public_decrypt:#{rsa_public_decrypt}"
  
  value2 = e.rsa_public_encrypt("another message" , publickey)
  puts "rsa_public_encrypt:#{value2}"
  rsa_private_decrypt = e.rsa_private_decrypt(value2 , privatekey)
  puts "rsa_private_decrypt:#{rsa_private_decrypt}"
  
  puts "----------------------------"
  rsa = OpenSSL::PKey::RSA.new(1024 , 7)
  value3 = rsa.private_encrypt("myself key")
  puts value3
  puts rsa.public_decrypt(value3)
end

testrun