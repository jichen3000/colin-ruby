require 'test/unit'
require 'loit_sort'

class LoitSortPerformTest < Test::Unit::TestCase
#  def test_gen_table_some
#    arr = LoitSortPerform.gen_table_some(128, 32)
#    LoitSortPerform.p_bin_arr(arr)
#  end
#  def test_get_block_single_16
#    value = ('00111000'+'00000000'+
#             '11111111'+'11111111'+
#             '00000000'+'00000000'+
#             '10101010'+'01010101').to_i(2)
#    assert_equal(LoitSortPerform.get_block_single_16(value,[],1,8),
#      [[1, 1], [3, 1], [5, 1], [7, 1]])
#    assert_equal(LoitSortPerform.get_block_single_16(value,[],17,24),
#      [])
#    assert_equal(LoitSortPerform.get_block_single_16(value,[],33,40),
#      [[33, 1], [34, 1], [35, 1], [36, 1], [37, 1], [38, 1], [39, 1], [40, 1]])
#  end
#  def test_get_block_64
#    value = ('00111000'+'00000000'+
#             '11111111'+'11111111'+
#             '00000000'+'00000000'+
#             '10101010'+'01010101').to_i(2)
#    assert_equal(LoitSortPerform.get_block_64(value,[]),
#      [[1, 1], [3, 1], [5, 1], [7, 1], [10, 1], [12, 1], [14, 1], 
#      [16, 1], [33, 16], [60, 1], [61, 1], [62, 1]])
#    assert_equal(LoitSortPerform.get_block_64(0,[]),
#      [])
#    assert_equal(LoitSortPerform.get_block_64((1<<63)-1,[]),
#      [[1, 63]])
#  end
#  def test_get_total_arr
#    p LoitSortPerform.get_total_arr('testloit01.log')
#  end
#  def test_gen_continue_1
#    assert_equal( LoitSortPerform.gen_continue_1(5,8).to_s(2),"11110000")
#  end
#  def test_do_get_blockcount
#    arr = LoitSortPerform.gen_0_arr
#    arr_index = 0
#    value_index = 63
#    block_count = 90
#    LoitSortPerform.do_get_blockcount(arr,arr_index,value_index,block_count)
#    LoitSortPerform.puts_afn_arr([arr])
#  end
  def test_sort
    
    arr = LoitSortPerform.get_total_arr_short_3('testloit01.log')
#    arr = LoitSortPerform.get_total_arr_short('testloit01.log')
#    LoitSortPerform.puts_afn_arr(arr)
#    P arr
#    arr_0 = ['11110000'.to_i(2),'11'.to_i(2)]
#    arr_1 = ['11110000'.to_i(2),'1100'.to_i(2)]
#    arr = [arr_0,arr_1]
    LoitSortPerform.sort(arr,'r_01.log')
  end
  
end