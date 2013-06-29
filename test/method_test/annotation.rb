module Annotations
  def annotations(meth=nil)
    return @__annotations__[meth] if meth
    @__annotations__
  end

  private

  def method_added(m)
    (@__annotations__ ||= {})[m] = @__last_annotation__ if @__last_annotation__
    @__last_annotation__ = nil
    super
  end

  def method_missing(meth, *args)
    return super unless /\A_/ =~ meth
    @__last_annotation__ ||= {}
    @__last_annotation__[meth[1..-1].to_sym] = args.size == 1 ? args.first : args
  end
end

class Module
  private

  def annotate!
    extend Annotations
  end
end
class A
  annotate!

  _hello   color: 'red',   ancho:   23
  _goodbye color: 'green', alto:  -123
  _foobar  color: 'blew'
  def m1; end

  def m2; end

  _foobar  color: 'cyan'
  def m3; end
end
require 'test/unit'
class TestAnnotations < Test::Unit::TestCase
  def test_that_m1_is_annotated_with_hello_and_has_value_red
    assert_equal 'red', A.annotations(:m1)[:hello][:color]
  end
  def test_that_m3_is_annotated_with_foobar_and_has_value_cyan
    assert_equal 'cyan', A.annotations[:m3][:foobar][:color]
  end
  def test_that_m1_is_annotated_with_goodbye
    assert A.annotations[:m1][:goodbye]
  end
  def test_that_all_annotations_are_there
    annotations = {
      m1: {
        hello:   { color: 'red',   ancho:   23 },
        goodbye: { color: 'green', alto:  -123 },
        foobar:  { color: 'blew'               }
      },
      m3: {
        foobar:  { color: 'cyan'               }
      }
    }
    assert_equal annotations, A.annotations
  end
end
