=begin
###################
  need require 'rake'
* %p — The complete path.
* %f — The base file name of the path, with its file extension, but without any directories.
* %n — The file name of the path without its file extension.
* %d — The directory list of the path.
* %x — The file extension of the path. An empty string if there is no extension.
* %X — Everything but the file extension.
* %s — The alternate file separater if defined, otherwise use the standard file separator.
* %% — A percent sign.

###################
=end




require 'test/unit'
require 'rake'

class TestPathmap < Test::Unit::TestCase
  def setup
    @path1 = 'a/b/c/d/file.txt'
    @path2 = '/e/f/g/file.txt'
  end
  def testOne
#    puts @path1.pathmap("%2d")
    assert('a/b/c/d/file.txt'.pathmap("%2d"),'a/b')
    assert('a/b/c/d/file.txt'.pathmap("%-2d"),'c/d')
    assert("src/org/onestepback/proj/A.java".pathmap("%{^src,bin}X.class"),
        "bin/org/onestepback/proj/A.class")
    assert('a/b/c/d/file.txt'.pathmap("/ef%s%p"),'/ef\a/b/c/d/file.txt')
    assert('a/b/c/d/file.txt'.pathmap("/ef/%p"),'/ef/a/b/c/d/file.txt')
    assert('a/b/c/d/file.txt'.pathmap("/ef/%f"),'/ef/file.txt')
  end
end