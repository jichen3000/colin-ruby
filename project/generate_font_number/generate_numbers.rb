require 'haml'
require 'pp'

def mypp(msg)
    msg
end

def get_font_families()
    %W( Antiqua Arial   Blackletter Calibri #{"Comic Sans"}   
        Courier Cursive Decorative  Fantasy Fraktur Frosty  Garamond    Georgia Helvetica   
        Impact  Minion  Modern  Monospace   Palatino    Roman   #{"Sans-serif"}  Serif   Script  
        Swiss   Times   #{"Times New Roman"} Verdana)     
end

def change_program_name(name, specials={"Sans-serif"=>"sans_serif"})
    if specials.keys.include?(name)
        return specials[name]
    else
        return name.downcase().gsub(' ', '_')
    end
end



def run_haml()
    template = File.read('font_numbers.haml')

    engine = Haml::Engine.new(template)
    # pp engine

    font_families = get_font_families()
    font_with_names = font_families.map{|f| [change_program_name(f), f]}
    font_styles = %w{normal italic}
    font_weights = %w{normal bold}


    print 'font_families = ',font_families
    puts
    print 'font_familie_names = ',font_families.map{|f| change_program_name(f)}
    puts
    print 'font_styles = ',font_styles
    puts
    print 'font_weights = ',font_weights
    puts
    htmls = engine.render(Object.new, locals=
        {:font_with_names => font_with_names,
         :font_weights => font_weights,
         :font_styles => font_styles})
    File.write('font_numbers.html', htmls)
end

if __FILE__ == $0
    run_haml()
end

    # :css
    #   div.arial{
    #     width: 441px;
    #   }
    #   div.courier{
    #     width: 541px;
    #   }
    #   div.georgia{
    #     width: 428px;
    #   }
    #   div.helvetica{
    #     width: 441px;
    #   }
    #   div.impact{
    #     width: 393px;
    #   }
    #   div.verdana{
    #     width: 479px;
    #   }

