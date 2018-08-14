require 'erb'

def gen_cmd(name, mode=nil)
    cmd_str = %Q{
edit <%= name %>
<% if mode %>
    set <%= mode %>
<% end %>}
    ERB.new(cmd_str).result(binding)
end

def gen_cmd_without_newline(name, mode=nil)
    cmd_str = %Q{
edit <%= name %>
<% if mode %>
    set <%= mode %>
<% end %>}
    # the second is for sandbox thread
    # the third is for new line
    ERB.new(cmd_str, 0, '>').result(binding)
end

def gen_with_hash(the_hash)
        cmd_str = %Q{
edit "<%= the_hash[:name] %>"
    set <%= the_hash[:mode] %>
end
        }
        ERB.new(cmd_str).result(binding).strip
end
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    food = "bacon"

    describe "erb" do
        it "basic" do
            t = ERB.new("Chunky <%= food %>!")
            t.result.must_equal("Chunky bacon!")
            t = ERB.new %{Chunky <%= food %>!}
            t.result.must_equal("Chunky bacon!")

            gen_cmd("t1","mm").must_equal("\nedit t1\n\n    set mm\n")

            gen_cmd_without_newline("t1","mm").must_equal("\nedit t1    set mm")
            gen_cmd_without_newline("t1").must_equal("\nedit t1")

            gen_with_hash({name:"t1",mode:"mm"}).must_equal("edit \"t1\"\n    set mm\nend")

        end
    end
end
