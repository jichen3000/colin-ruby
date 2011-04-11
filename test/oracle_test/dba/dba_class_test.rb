require 'rr'
require 'test/unit'
require 'dba_class'

class TestDba < Test::Unit::TestCase
  include RR::Adapters::TestUnit
  def setup
    @dba_1 = '0A016778'
    @afn_1 = 40
    @block_no_1 = 92024 
    @dba_2 = '0A116778'
    @afn_2 = 40
    @block_no_2 = 1140600 
    @dba_start = '00400000'
    @afn_start = 1
    @block_no_start = 0 
    @dba_end = '007fffff'
    @afn_end = 1
    @block_no_end = Dba::TO22_1 
  end
  def test_ana_old
    assert_equal(Dba.ana_old( @dba_1 ),[ @afn_1, @block_no_1])
    assert_equal(Dba.ana_old( @dba_2 ),[ @afn_2, @block_no_2])
  end
  def test_ana4s
    assert_equal(Dba.ana4s( @dba_1 ),[ @afn_1, @block_no_1])
    assert_equal(Dba.ana4s( @dba_2 ),[ @afn_2, @block_no_2])
  end
  def test_ana4i
    assert_equal(Dba.ana4i( @dba_1.hex ),[ @afn_1, @block_no_1])
    assert_equal(Dba.ana4i( @dba_2.hex ),[ @afn_2, @block_no_2])
  end
  def test_gen_to_s8
    assert_equal(Dba.gen_to_s8(@afn_1, @block_no_1).upcase, @dba_1)
    assert_equal(Dba.gen_to_s8(@afn_2, @block_no_2).upcase, @dba_2)
    assert_equal(Dba.gen_to_s8(@afn_start, @block_no_start), @dba_start)
    assert_equal(Dba.gen_to_s8(@afn_end, @block_no_end), @dba_end)
  end
  def test_gen_rand_dba_array
    stub(Dba).rand(2).returns(0)
    mock(Dba).rand(Dba::TO22_3).returns(0)
    mock(Dba).rand(Dba::TO22_3).returns(Dba::TO22_3)
    assert_equal(Dba.gen_rand_dba_array(2,2),["00400002".hex, "007fffff".hex])
  end
  def test_gen_rand_afndba_arr
    stub(Dba).rand(2).returns(0)
    mock(Dba).rand(Dba::TO22_3).returns(0)
    mock(Dba).rand(Dba::TO22_3).returns(Dba::TO22_3)
    assert_equal(Dba.gen_rand_afndba_arr(2,2),[[1,"00400002".hex], [1, "007fffff".hex]])
  end
  def test_afn_itos4
    assert_equal(Dba.afn_itos4(@afn_1),'0028')
  end
  def test_dba_itos8
    assert_equal(Dba.dba_itos8(@dba_1.hex),'0a016778')
  end
end
