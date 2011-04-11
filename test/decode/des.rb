require 'openssl'
def des_encrypt(plaintext)
  c = OpenSSL::Cipher::Cipher.new("DES")
  c.encrypt
  c.key = KEY
  ret = c.update(plaintext)
  ret << c.final
end

def des_decrypt(encrypt_value)
  c = OpenSSL::Cipher::Cipher.new("DES")
  c.decrypt
  c.key = KEY
  ret = c.update(encrypt_value)
  ret << c.final
end

KEY = "1234567890"

mm = "I am not a MM!"
c = OpenSSL::Cipher::Cipher.new("DES")
c.encrypt
c.key = KEY
p c.update(mm)


p "ok"
