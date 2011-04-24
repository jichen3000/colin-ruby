require File.join(File.dirname(__FILE__),'sub_add')
#first_filename = 'D:\down\chrome\1\[³¬Ô½áÛ·å].The.Climbers.High.2008.JAP.DVDRip.XviD-AKAGI-cd1.srt'
#second_filename =  'D:\down\chrome\1\[³¬Ô½áÛ·å].The.Climbers.High.2008.JAP.DVDRip.XviD-AKAGI-cd2.srt'
#new_filename = 'D:\down\chrome\1\new.srt'
#sj = SubJoin.new(first_filename,new_filename)
#sj.add_sub_file(second_filename,'01:10:32,190')
#sj.perform

first_filename = 'E:\videos\110.ch.srt'
new_filename ='E:\videos\[16½ÖÇø].16.Blocks.2006.BDRip.X264-TLF.ch.srt'
sct = SubChangeTime.new(first_filename,new_filename)
sct.perform("+",'00:00:20,000')


p new_filename+'  ok'