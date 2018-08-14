require 'haml'

# def gen_cmd(name, mode=nil)
#     cmd_str = %Q{
# edit #{name}
# - if mode
#     unset mode
# end
#     }
#     # engine = Haml::Engine.new(cmd_str)
#     Haml::Engine.new(cmd_str).render(Object.new, {:name => name, :mode => mode})
# end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "haml" do
        # it "gen_cmd" do
        #     gen_cmd('t1','mm').must_equal("edit t1\n    unset ")
        # end
        it "simple" do
            engine = Haml::Engine.new("%p Haml code!")
            engine.render.must_equal("<p>Haml code!</p>\n")
        end
        it "with parameter" do
            the_str="foober"
            Haml::Engine.new("%p= upcase").render(the_str).must_equal("<p>FOOBER</p>\n")
            engine = Haml::Engine.new('%p= foo')
            engine.render(Object.new, :foo => "Hello, world!").must_equal("<p>Hello, world!</p>\n")

        end
        it "raw html" do
            engine = Haml::Engine.new('%div= foo')
            engine.render(Object.new, :foo => "<a href='http://www.a.com'>Test</a>").must_equal(
                    "<div><a href='http://www.a.com'>Test</a></div>\n")

        end

        it "haml file" do
            content = File.open('test.haml').read()
            engine = Haml::Engine.new(content)
            engine.render.must_equal("<!DOCTYPE html>\n<html>\n  <p>Haml code!</p>\n</html>\n")
        end

        it 'gen link html' do
            start_date_str = "2014-12-01"
            end_date_str = "2014-12-05"
            links = [{:author_name=>"\u7B2C\u4E00\u6703\u6240\u65B0\u7247",
                      :date=>"2014-12-5",
                      :href=>"thread-9261518-1-6.html",
                      :title=>
                       "(\u30D3\u30D3\u30A2\u30F3)(BBAN-022)"},
                     {:author_name=>"\u7B2C\u4E00\u6703\u6240\u65B0\u7247",
                      :date=>"2014-12-3",
                      :href=>"thread-9261517-1-6.html",
                      :title=>
                       "(\u5984\u60F3\u65CF)(ATFB-239)\u5B50\u4F5C\u308A\u304A\u306D\u3060\u308A\u6DEB\u8A9E \u4F73\u82D7\u308B\u304B"}]
            tmplate_path = "links.haml"
            html_path = "links_#{start_date_str}_to_#{end_date_str}.html"
            base_url = "http://68.168.16.150/bbs/"
            # Haml::Options.defaults[:format] = :html5
            engine = Haml::Engine.new(File.open(tmplate_path).read())
            content = engine.render(Object.new, 
                {start_date_str:start_date_str,
                 end_date_str:end_date_str,
                 base_url:base_url,
                 links:links.reverse})
            # content.ppt()
            File.open(html_path,'w').write(content)
        end
    end
end