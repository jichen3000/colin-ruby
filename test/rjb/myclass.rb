require 'rjb'
Rjb.load("D:/work/workspace/colin-java/bin/.")

jMyClass = Rjb::import('com.colin.test.rjb.MyClass')
my = jMyClass.new(123,'jcjc')
p my.name
p my.myid
p my._classname
sleep(1000000)
p "ok"