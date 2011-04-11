#include <ruby.h>
#include <stdio.h>

static VALUE rb_mExample;
static VALUE rb_cClass;

static VALUE print_string(VALUE class, VALUE arg)
{
  printf("%s", RSTRING(arg)->ptr);
  return Qnil;
}
void Init_example()
{
  rb_mExample = rb_define_module("Example");

  rb_cClass = rb_define_class_under(rb_mExample, "Class", rb_cObject);

  rb_define_method(rb_cClass, "print_string", print_string, 1);
}

