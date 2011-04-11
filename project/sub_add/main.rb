require File.join(File.dirname(__FILE__),'sub_add')
first_filename = 'D:\down\chrome\1\[≥¨‘Ω·€∑Â].The.Climbers.High.2008.JAP.DVDRip.XviD-AKAGI-cd1.srt'
second_filename =  'D:\down\chrome\1\[≥¨‘Ω·€∑Â].The.Climbers.High.2008.JAP.DVDRip.XviD-AKAGI-cd2.srt'
new_filename = 'D:\down\chrome\1\new.srt'
sj = SubJoin.new(first_filename,new_filename)
sj.add_sub_file(second_filename,'01:10:32,190')
sj.perform

p new_filename+'  ok'