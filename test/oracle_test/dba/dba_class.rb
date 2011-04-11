class Dba
#  TO22 = 4194304
#  TO22_1 = 4194303
#  TO22_3 = 4194301
  TO22 = 524288
  TO22_1 = 524287
  TO22_3 = 524285
  class << self
    def ana_afn_dba(line)
      afn,dba = line.split(' ')
      [afn.hex,(dba.hex & TO22_1)]
    end
    def gen_rand_dba_array(afn_range,size)
      arr = []
      size.times do |i|
        # because start from 2, block_no 0 is os header, 1 is ora header. 
        arr << gen_to_i(rand(afn_range)+1,rand(TO22_3)+2)
      end      
      arr
    end
    def gen_rand_afndba_arr(afn_range,size)
      arr = []
      size.times do |i|
        afn = rand(afn_range)+1
        # because start from 2, block_no 0 is os header, 1 is ora header. 
        arr << [afn,gen_to_i(afn,rand(TO22_3)+2)]
      end      
      arr      
    end
    def gen_to_s8(afn,block_no)
      ((afn << 22)+block_no).to_s(16).rjust(8,"0")
    end
    def gen_to_i(afn,block_no)
      (afn << 22)+block_no
    end
    def dba_itos8(dba)
      dba.to_s(16).rjust(8,"0")
    end
    def afn_itos4(afn)
      afn.to_s(16).rjust(4,"0")
    end
    def ana4s(dba)
      dba = dba.hex
#      ana4i(dba) 
      [(dba >> 22), (dba & TO22_1)]
    end
    def ana4i(dba)
      [(dba >> 22), (dba & TO22_1)]
    end
    def ana4i_block_no(dba)
      dba & TO22_1
    end
    def ana_old(dba)
      front = dba[0..2].hex
      rfn = (front/4)        #/
      block_no =(front%4)*1048576 + dba[3..-1].hex
      front = nil 
      [rfn,block_no]
    end
  end
end

#dba = '008070A7'
#dba = '0A016778'
#p Dba.ana4s(dba)
