def checksum(block)
  checksum = "\000\000"
  count = block.size/2
  count.times do |index|
    checksum[0] = checksum[0] ^ block[index*2]
    checksum[1] = checksum[1] ^ block[index*2+1]
  end
  checksum
end
def checksum16(block)
  inter_count = 16
  if (block.size % inter_count) != 0
    raise "must 16"
  end
  checksum = "\000\000"
  count = block.size/inter_count
  count.times do |index|
    start_index = index*inter_count
    checksum[0] = checksum[0] ^ block[start_index] ^ block[start_index+2] ^ 
      block[start_index+4] ^ block[start_index+6] ^ 
      block[start_index+8] ^ block[start_index+10] ^ 
      block[start_index+12] ^ block[start_index+14]
    checksum[1] = checksum[1] ^ block[start_index+1] ^ block[start_index+3] ^ 
      block[start_index+5] ^ block[start_index+7] ^
      block[start_index+9] ^ block[start_index+11] ^ 
      block[start_index+13] ^ block[start_index+15]
  end
  checksum
end
def checksum32(block)
  inter_count = 32
  if (block.size % inter_count) != 0
    raise "must 32"
  end
  checksum = "\000\000"
  count = block.size/inter_count
  count.times do |index|
    start_index = index*inter_count
    checksum[0] = checksum[0] ^ block[start_index] ^ block[start_index+2] ^ 
      block[start_index+4] ^ block[start_index+6] ^ 
      block[start_index+8] ^ block[start_index+10] ^ 
      block[start_index+12] ^ block[start_index+14] ^ 
      block[start_index+16] ^ block[start_index+18] ^ 
      block[start_index+20] ^ block[start_index+22] ^ 
      block[start_index+24] ^ block[start_index+26] ^ 
      block[start_index+28] ^ block[start_index+30] 
    checksum[1] = checksum[1] ^ block[start_index+1] ^ block[start_index+3] ^ 
      block[start_index+5] ^ block[start_index+7] ^
      block[start_index+9] ^ block[start_index+11] ^ 
      block[start_index+13] ^ block[start_index+15] ^ 
      block[start_index+17] ^ block[start_index+19] ^ 
      block[start_index+21] ^ block[start_index+23] ^ 
      block[start_index+25] ^ block[start_index+27] ^ 
      block[start_index+29] ^ block[start_index+31] 
  end
  checksum
end
def checksum512(block)
  inter_count = 512
  if (block.size % inter_count) != 0
    raise "must 512"
  end
  checksum = "\000\000"
  count = block.size/inter_count
  count.times do |index|
    start_index = index*inter_count
    checksum[0] = checksum[0] ^ block[start_index] ^ block[start_index+2] ^ 
      block[start_index+4] ^ block[start_index+6] ^ 
      block[start_index+8] ^ block[start_index+10] ^ 
      block[start_index+12] ^ block[start_index+14] ^ 
      block[start_index+16] ^ block[start_index+18] ^ 
      block[start_index+20] ^ block[start_index+22] ^ 
      block[start_index+24] ^ block[start_index+26] ^ 
      block[start_index+28] ^ block[start_index+30] ^ 
      block[start_index+32] ^ block[start_index+34] ^ 
      block[start_index+36] ^ block[start_index+38] ^ 
      block[start_index+40] ^ block[start_index+42] ^ 
      block[start_index+44] ^ block[start_index+46] ^ 
      block[start_index+48] ^ block[start_index+50] ^ 
      block[start_index+52] ^ block[start_index+54] ^ 
      block[start_index+56] ^ block[start_index+58] ^ 
      block[start_index+60] ^ block[start_index+62] ^ 
      block[start_index+64] ^ block[start_index+66] ^ 
      block[start_index+68] ^ block[start_index+70] ^ 
      block[start_index+72] ^ block[start_index+74] ^ 
      block[start_index+76] ^ block[start_index+78] ^ 
      block[start_index+80] ^ block[start_index+82] ^ 
      block[start_index+84] ^ block[start_index+86] ^ 
      block[start_index+88] ^ block[start_index+90] ^ 
      block[start_index+92] ^ block[start_index+94] ^ 
      block[start_index+96] ^ block[start_index+98] ^ 
      block[start_index+100] ^ block[start_index+102] ^ 
      block[start_index+104] ^ block[start_index+106] ^ 
      block[start_index+108] ^ block[start_index+110] ^ 
      block[start_index+112] ^ block[start_index+114] ^ 
      block[start_index+116] ^ block[start_index+118] ^ 
      block[start_index+120] ^ block[start_index+122] ^ 
      block[start_index+124] ^ block[start_index+126] ^ 
      block[start_index+128] ^ block[start_index+130] ^ 
      block[start_index+132] ^ block[start_index+134] ^ 
      block[start_index+136] ^ block[start_index+138] ^ 
      block[start_index+140] ^ block[start_index+142] ^ 
      block[start_index+144] ^ block[start_index+146] ^ 
      block[start_index+148] ^ block[start_index+150] ^ 
      block[start_index+152] ^ block[start_index+154] ^ 
      block[start_index+156] ^ block[start_index+158] ^ 
      block[start_index+160] ^ block[start_index+162] ^ 
      block[start_index+164] ^ block[start_index+166] ^ 
      block[start_index+168] ^ block[start_index+170] ^ 
      block[start_index+172] ^ block[start_index+174] ^ 
      block[start_index+176] ^ block[start_index+178] ^ 
      block[start_index+180] ^ block[start_index+182] ^ 
      block[start_index+184] ^ block[start_index+186] ^ 
      block[start_index+188] ^ block[start_index+190] ^ 
      block[start_index+192] ^ block[start_index+194] ^ 
      block[start_index+196] ^ block[start_index+198] ^ 
      block[start_index+200] ^ block[start_index+202] ^ 
      block[start_index+204] ^ block[start_index+206] ^ 
      block[start_index+208] ^ block[start_index+210] ^ 
      block[start_index+212] ^ block[start_index+214] ^ 
      block[start_index+216] ^ block[start_index+218] ^ 
      block[start_index+220] ^ block[start_index+222] ^ 
      block[start_index+224] ^ block[start_index+226] ^ 
      block[start_index+228] ^ block[start_index+230] ^ 
      block[start_index+232] ^ block[start_index+234] ^ 
      block[start_index+236] ^ block[start_index+238] ^ 
      block[start_index+240] ^ block[start_index+242] ^ 
      block[start_index+244] ^ block[start_index+246] ^ 
      block[start_index+248] ^ block[start_index+250] ^ 
      block[start_index+252] ^ block[start_index+254] ^ 
      block[start_index+256] ^ block[start_index+258] ^ 
      block[start_index+260] ^ block[start_index+262] ^ 
      block[start_index+264] ^ block[start_index+266] ^ 
      block[start_index+268] ^ block[start_index+270] ^ 
      block[start_index+272] ^ block[start_index+274] ^ 
      block[start_index+276] ^ block[start_index+278] ^ 
      block[start_index+280] ^ block[start_index+282] ^ 
      block[start_index+284] ^ block[start_index+286] ^ 
      block[start_index+288] ^ block[start_index+290] ^ 
      block[start_index+292] ^ block[start_index+294] ^ 
      block[start_index+296] ^ block[start_index+298] ^ 
      block[start_index+300] ^ block[start_index+302] ^ 
      block[start_index+304] ^ block[start_index+306] ^ 
      block[start_index+308] ^ block[start_index+310] ^ 
      block[start_index+312] ^ block[start_index+314] ^ 
      block[start_index+316] ^ block[start_index+318] ^ 
      block[start_index+320] ^ block[start_index+322] ^ 
      block[start_index+324] ^ block[start_index+326] ^ 
      block[start_index+328] ^ block[start_index+330] ^ 
      block[start_index+332] ^ block[start_index+334] ^ 
      block[start_index+336] ^ block[start_index+338] ^ 
      block[start_index+340] ^ block[start_index+342] ^ 
      block[start_index+344] ^ block[start_index+346] ^ 
      block[start_index+348] ^ block[start_index+350] ^ 
      block[start_index+352] ^ block[start_index+354] ^ 
      block[start_index+356] ^ block[start_index+358] ^ 
      block[start_index+360] ^ block[start_index+362] ^ 
      block[start_index+364] ^ block[start_index+366] ^ 
      block[start_index+368] ^ block[start_index+370] ^ 
      block[start_index+372] ^ block[start_index+374] ^ 
      block[start_index+376] ^ block[start_index+378] ^ 
      block[start_index+380] ^ block[start_index+382] ^ 
      block[start_index+384] ^ block[start_index+386] ^ 
      block[start_index+388] ^ block[start_index+390] ^ 
      block[start_index+392] ^ block[start_index+394] ^ 
      block[start_index+396] ^ block[start_index+398] ^ 
      block[start_index+400] ^ block[start_index+402] ^ 
      block[start_index+404] ^ block[start_index+406] ^ 
      block[start_index+408] ^ block[start_index+410] ^ 
      block[start_index+412] ^ block[start_index+414] ^ 
      block[start_index+416] ^ block[start_index+418] ^ 
      block[start_index+420] ^ block[start_index+422] ^ 
      block[start_index+424] ^ block[start_index+426] ^ 
      block[start_index+428] ^ block[start_index+430] ^ 
      block[start_index+432] ^ block[start_index+434] ^ 
      block[start_index+436] ^ block[start_index+438] ^ 
      block[start_index+440] ^ block[start_index+442] ^ 
      block[start_index+444] ^ block[start_index+446] ^ 
      block[start_index+448] ^ block[start_index+450] ^ 
      block[start_index+452] ^ block[start_index+454] ^ 
      block[start_index+456] ^ block[start_index+458] ^ 
      block[start_index+460] ^ block[start_index+462] ^ 
      block[start_index+464] ^ block[start_index+466] ^ 
      block[start_index+468] ^ block[start_index+470] ^ 
      block[start_index+472] ^ block[start_index+474] ^ 
      block[start_index+476] ^ block[start_index+478] ^ 
      block[start_index+480] ^ block[start_index+482] ^ 
      block[start_index+484] ^ block[start_index+486] ^ 
      block[start_index+488] ^ block[start_index+490] ^ 
      block[start_index+492] ^ block[start_index+494] ^ 
      block[start_index+496] ^ block[start_index+498] ^ 
      block[start_index+500] ^ block[start_index+502] ^ 
      block[start_index+504] ^ block[start_index+506] ^ 
      block[start_index+508] ^ block[start_index+510]  
    checksum[1] = checksum[1] ^ block[start_index+1] ^ block[start_index+3] ^ 
      block[start_index+5] ^ block[start_index+7] ^ 
      block[start_index+9] ^ block[start_index+11] ^ 
      block[start_index+13] ^ block[start_index+15] ^ 
      block[start_index+17] ^ block[start_index+19] ^ 
      block[start_index+21] ^ block[start_index+23] ^ 
      block[start_index+25] ^ block[start_index+27] ^ 
      block[start_index+29] ^ block[start_index+31] ^ 
      block[start_index+33] ^ block[start_index+35] ^ 
      block[start_index+37] ^ block[start_index+39] ^ 
      block[start_index+41] ^ block[start_index+43] ^ 
      block[start_index+45] ^ block[start_index+47] ^ 
      block[start_index+49] ^ block[start_index+51] ^ 
      block[start_index+53] ^ block[start_index+55] ^ 
      block[start_index+57] ^ block[start_index+59] ^ 
      block[start_index+61] ^ block[start_index+63] ^ 
      block[start_index+65] ^ block[start_index+67] ^ 
      block[start_index+69] ^ block[start_index+71] ^ 
      block[start_index+73] ^ block[start_index+75] ^ 
      block[start_index+77] ^ block[start_index+79] ^ 
      block[start_index+81] ^ block[start_index+83] ^ 
      block[start_index+85] ^ block[start_index+87] ^ 
      block[start_index+89] ^ block[start_index+91] ^ 
      block[start_index+93] ^ block[start_index+95] ^ 
      block[start_index+97] ^ block[start_index+99] ^ 
      block[start_index+101] ^ block[start_index+103] ^ 
      block[start_index+105] ^ block[start_index+107] ^ 
      block[start_index+109] ^ block[start_index+111] ^ 
      block[start_index+113] ^ block[start_index+115] ^ 
      block[start_index+117] ^ block[start_index+119] ^ 
      block[start_index+121] ^ block[start_index+123] ^ 
      block[start_index+125] ^ block[start_index+127] ^ 
      block[start_index+129] ^ block[start_index+131] ^ 
      block[start_index+133] ^ block[start_index+135] ^ 
      block[start_index+137] ^ block[start_index+139] ^ 
      block[start_index+141] ^ block[start_index+143] ^ 
      block[start_index+145] ^ block[start_index+147] ^ 
      block[start_index+149] ^ block[start_index+151] ^ 
      block[start_index+153] ^ block[start_index+155] ^ 
      block[start_index+157] ^ block[start_index+159] ^ 
      block[start_index+161] ^ block[start_index+163] ^ 
      block[start_index+165] ^ block[start_index+167] ^ 
      block[start_index+169] ^ block[start_index+171] ^ 
      block[start_index+173] ^ block[start_index+175] ^ 
      block[start_index+177] ^ block[start_index+179] ^ 
      block[start_index+181] ^ block[start_index+183] ^ 
      block[start_index+185] ^ block[start_index+187] ^ 
      block[start_index+189] ^ block[start_index+191] ^ 
      block[start_index+193] ^ block[start_index+195] ^ 
      block[start_index+197] ^ block[start_index+199] ^ 
      block[start_index+201] ^ block[start_index+203] ^ 
      block[start_index+205] ^ block[start_index+207] ^ 
      block[start_index+209] ^ block[start_index+211] ^ 
      block[start_index+213] ^ block[start_index+215] ^ 
      block[start_index+217] ^ block[start_index+219] ^ 
      block[start_index+221] ^ block[start_index+223] ^ 
      block[start_index+225] ^ block[start_index+227] ^ 
      block[start_index+229] ^ block[start_index+231] ^ 
      block[start_index+233] ^ block[start_index+235] ^ 
      block[start_index+237] ^ block[start_index+239] ^ 
      block[start_index+241] ^ block[start_index+243] ^ 
      block[start_index+245] ^ block[start_index+247] ^ 
      block[start_index+249] ^ block[start_index+251] ^ 
      block[start_index+253] ^ block[start_index+255] ^ 
      block[start_index+257] ^ block[start_index+259] ^ 
      block[start_index+261] ^ block[start_index+263] ^ 
      block[start_index+265] ^ block[start_index+267] ^ 
      block[start_index+269] ^ block[start_index+271] ^ 
      block[start_index+273] ^ block[start_index+275] ^ 
      block[start_index+277] ^ block[start_index+279] ^ 
      block[start_index+281] ^ block[start_index+283] ^ 
      block[start_index+285] ^ block[start_index+287] ^ 
      block[start_index+289] ^ block[start_index+291] ^ 
      block[start_index+293] ^ block[start_index+295] ^ 
      block[start_index+297] ^ block[start_index+299] ^ 
      block[start_index+301] ^ block[start_index+303] ^ 
      block[start_index+305] ^ block[start_index+307] ^ 
      block[start_index+309] ^ block[start_index+311] ^ 
      block[start_index+313] ^ block[start_index+315] ^ 
      block[start_index+317] ^ block[start_index+319] ^ 
      block[start_index+321] ^ block[start_index+323] ^ 
      block[start_index+325] ^ block[start_index+327] ^ 
      block[start_index+329] ^ block[start_index+331] ^ 
      block[start_index+333] ^ block[start_index+335] ^ 
      block[start_index+337] ^ block[start_index+339] ^ 
      block[start_index+341] ^ block[start_index+343] ^ 
      block[start_index+345] ^ block[start_index+347] ^ 
      block[start_index+349] ^ block[start_index+351] ^ 
      block[start_index+353] ^ block[start_index+355] ^ 
      block[start_index+357] ^ block[start_index+359] ^ 
      block[start_index+361] ^ block[start_index+363] ^ 
      block[start_index+365] ^ block[start_index+367] ^ 
      block[start_index+369] ^ block[start_index+371] ^ 
      block[start_index+373] ^ block[start_index+375] ^ 
      block[start_index+377] ^ block[start_index+379] ^ 
      block[start_index+381] ^ block[start_index+383] ^ 
      block[start_index+385] ^ block[start_index+387] ^ 
      block[start_index+389] ^ block[start_index+391] ^ 
      block[start_index+393] ^ block[start_index+395] ^ 
      block[start_index+397] ^ block[start_index+399] ^ 
      block[start_index+401] ^ block[start_index+403] ^ 
      block[start_index+405] ^ block[start_index+407] ^ 
      block[start_index+409] ^ block[start_index+411] ^ 
      block[start_index+413] ^ block[start_index+415] ^ 
      block[start_index+417] ^ block[start_index+419] ^ 
      block[start_index+421] ^ block[start_index+423] ^ 
      block[start_index+425] ^ block[start_index+427] ^ 
      block[start_index+429] ^ block[start_index+431] ^ 
      block[start_index+433] ^ block[start_index+435] ^ 
      block[start_index+437] ^ block[start_index+439] ^ 
      block[start_index+441] ^ block[start_index+443] ^ 
      block[start_index+445] ^ block[start_index+447] ^ 
      block[start_index+449] ^ block[start_index+451] ^ 
      block[start_index+453] ^ block[start_index+455] ^ 
      block[start_index+457] ^ block[start_index+459] ^ 
      block[start_index+461] ^ block[start_index+463] ^ 
      block[start_index+465] ^ block[start_index+467] ^ 
      block[start_index+469] ^ block[start_index+471] ^ 
      block[start_index+473] ^ block[start_index+475] ^ 
      block[start_index+477] ^ block[start_index+479] ^ 
      block[start_index+481] ^ block[start_index+483] ^ 
      block[start_index+485] ^ block[start_index+487] ^ 
      block[start_index+489] ^ block[start_index+491] ^ 
      block[start_index+493] ^ block[start_index+495] ^ 
      block[start_index+497] ^ block[start_index+499] ^ 
      block[start_index+501] ^ block[start_index+503] ^ 
      block[start_index+505] ^ block[start_index+507] ^ 
      block[start_index+509] ^ block[start_index+511]  
  end
  checksum
end
#str.each_char do |char|
#  char
#end

#block = ['00110011','00000011','11001100','11000011','11111100','00000000']
#block.map!{|x| x.to_i(2)}
#p block
#block = block.pack('C'*block.size)
#p block
#c = checksum(block)
#p c.unpack('CC')
#p checksum(str).unpack('n')[0].to_s(2).rjust(16,'0')
#def helper(count)
#  count.times do |index|
#    puts("      block[start_index+#{index*4}] ^ block[start_index+#{index*4+2}] ^ ")
#  end
#  count.times do |index|
#    puts("      block[start_index+#{index*4+1}] ^ block[start_index+#{index*4+3}] ^ ")
#  end
#end
#helper(128)
file = File.open('d:\tmp\log\bintest','rb')
block = file.read(512)
require 'Benchmark'
Benchmark.bm do |x|
  x.report("checksum") { 4_0000.times { checksum16(block)} }
end
p checksum(block).unpack('CC')
p "ok"