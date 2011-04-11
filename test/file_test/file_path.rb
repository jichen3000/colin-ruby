def absolute_path?(filename)
  return true  if filename.index('/') and filename.index('/')==0
  return true if filename.index(':')
  return false
end
p absolute_path?('/doc/run_rails_test.txt')
p absolute_path?('d:/doc/run_rails_test.txt')
p absolute_path?('d:\doc\run_rails_test.txt')

p absolute_path?('doc/run_rails_test.txt')
p absolute_path?('doc\run_rails_tests.txt')


def absolute_path2?(filename)
  filename.index('/')==0 or filename.index(':')!=nil
end
p absolute_path2?('/doc/run_rails_test.txt')
p absolute_path2?('d:/doc/run_rails_test.txt')
p absolute_path2?('d:\doc\run_rails_test.txt')


p absolute_path2?('doc/run_rails_test.txt')
p absolute_path2?('doc\run_rails_tests.txt')
filename = 'D:\work\workspace\colin-ruby\doc\run_rails_test.txt'
filename = "D:\\work\\workspace\\colin-ruby\\doc\\run_rails_test.txt"

File.open(filename)
