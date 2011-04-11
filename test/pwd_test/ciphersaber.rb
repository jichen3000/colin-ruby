=begin
Time-stamp: <2003/08/13 13:29:40 zophos>

== NAME

ciphersaber.rb -- CipherSaber with Arcfour

== AUTHOR

((<NISHI Takao|mailto:zophos@koka-in.org>))

== DESCRIPTION

ciphersaber.rb provids CipherSaber encrypt/decrypt methods and
Arcfour encrypt/decrypt methods to String class.

== METHODS

All methods are appended to String class.

=== cs_crypt(passwd,shuffle=1)
=== cs_encrypt(passwd,shuffle=1)

Encrypting with CipherSaber algorithm.

When shuffle larger than 1, encrypting with CipherSaber-2 algorithm. 

=== cs_decrypt(passwd,shuffle=1)

Decrypting with CipherSaber algorithm.

When shuffle larger than 2, decrypting with CipherSaber-2 algorithm. 

=== arcfour(key,shuffle=1)
=== af_crypt(key,shuffle=1)
=== af_encrypt(key,shuffle=1)
=== af_decrypt(key,shuffle=1)

Encrypting/decrypting with Arcfour algorithm.

== EXAMPLE

=== Decrypting with CipherSaber

  require 'ciphersaber'
  
  c=''
  File.open('cknight.cs1'){|f|
    c=f.read
  }
  
  c=c.cs_decrypt('ThomasJefferson')
  
  File.open('cknight.gif','w'){|f|
    f.write(c)
  }

=== Encrypting with CipherSaber-2

  require 'ciphersaber'
  
  plain_text='hogehoge'
  passwd='mogemoge'
  shuffle=20  # if shuffle==1 then same as CipherSaber-1
  
  encrypted_text=plain_text.cs_crypt(passwd,shuffle)


== ACKNOWLEDGMENT

If you want to use this library for any commercial product,
you SHOULD obtain RC4 licence from RSA Security Inc.

This is free software with ABSOLUTELY NO WARRANTY.

== REFERENCES

* ((<The CipherSaber Home Page|http://ciphersaber.gurus.com/>))
* ((<CipherSaber|http://www.hyuki.com/cs/>))
* ((<A Stream Cipher Encryption Algorithm "Arcfour"|http://www.mozilla.org/projects/security/pki/nss/draft-kaukonen-cipher-arcfour-03.txt>))

=end

class String

    #
    # Arcfour code/decode
    #
    def arcfour(key,shuffle=1)
	#
	# key setup
	#
	s=[]
	256.times{|i|
	    s.push(i)
	}

	s2=key.to_s.unpack('C*')
	key=nil
	while(s2.size<256)
	    s2+=s2
	end
	s2=s2[0..255]
	
	if(shuffle.to_i<1)
	    shuffle=1
	end
	j=0
	shuffle.to_i.times{|k|
	    256.times{|i|
		j=(j+s[i]+s2[i])%256
		tmp=s[i]
		s[i]=s[j]
		s[j]=tmp
	    }
	}
	shuffle=nil
	s2=nil

	#
	# code/decode
	#
	i=0
	j=0
	buf=[]
	self.unpack('C*').each{|c|
	    i=(i+1)%256
	    j=(j+s[i])%256
	    tmp=s[i]
	    s[i]=s[j]
	    s[j]=tmp
	    t=(s[i]+s[j])%256
	    buf.push(s[t]^c)
	}
	
	buf.pack('C*')
    end
    alias af_crypt arcfour
    alias af_encrypt arcfour
    alias af_decrypt arcfour
    
    #
    # CipherSaber Encrypt
    #
    def cs_crypt(passwd,shuffle=1)
	#
	# generate initialization vector
	#
	init_vector=[]
	10.times{|i|
	    init_vector.push(rand(256))
	}
	init_vector=init_vector.pack('C*')
	
	init_vector+
	    self.arcfour(passwd[0..245]+init_vector,shuffle)
    end
    alias cs_encrypt cs_crypt

    #
    # CipherSaber Decrypt
    #
    def cs_decrypt(passwd,shuffle=1)
	if(self.size<=10)
	    raise 'This string is not encrypted with CipherSaber.'
	end

	self[10..-1].arcfour(passwd[0..245]+self[0..9],shuffle)
    end
end

if(__FILE__==$0)
    cs1=[
	0x6f,0x6d,0x0b,0xab,0xf3,0xaa,0x67,0x19,
	0x03,0x15,0x30,0xed,0xb6,0x77,0xca,0x74,
	0xe0,0x08,0x9d,0xd0,0xe7,0xb8,0x85,0x43,
	0x56,0xbb,0x14,0x48,0xe3,0x7c,0xdb,0xef,
	0xe7,0xf3,0xa8,0x4f,0x4f,0x5f,0xb3,0xfd
    ].pack('C*')
    cs2=[
	0xba,0x9a,0xb4,0xcf,0xfb,0x77,0x00,0xe6,
	0x18,0xe3,0x82,0xe8,0xfc,0xc5,0xab,0x98,
	0x13,0xb1,0xab,0xc4,0x36,0xba,0x7d,0x5c,
	0xde,0xa1,0xa3,0x1f,0xb7,0x2f,0xb5,0x76,
	0x3c,0x44,0xcf,0xc2,0xac,0x77,0xaf,0xee,
	0x19,0xad
    ].pack('C*')
    p cs1.cs_decrypt('asdfg')
    p cs2.cs_decrypt('asdfg',10)
end
