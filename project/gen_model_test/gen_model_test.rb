class GenModelTest
  def initialize(class_name)
    @keywords = {:class_name=>class_name, 
                 :instance_name=>class_name_to_instance_name(class_name),
                 :column_name=>'name'}
  end
  def gen_yml_file(path)
    file_name = File.join(path,@keywords[:instance_name]+".yml")
    template_file_name = File.join(File.dirname(__FILE__),'templatefile','yml.template')
    gen_file(file_name,template_file_name)
  end
  def gen_rb_test_file(path)
    file_name = File.join(path,@keywords[:instance_name]+"_test.rb")
    template_file_name = File.join(File.dirname(__FILE__),'templatefile','test.template')
    gen_file(file_name,template_file_name)
  end
  def gen_model_file(path)
    file_name = File.join(path,@keywords[:instance_name]+".rb")
    template_file_name = File.join(File.dirname(__FILE__),'templatefile','model.template')
    gen_file(file_name,template_file_name)
  end
  def class_name_to_instance_name(class_name)
    str = ""
    class_name.each_byte do |b|
      if b >= 65 and b<=90
        str << "_" if str.length>0
        str << b +32
      else
        str << b
      end
    end
    return str
  end
  def instance_name_to_class_name(instance_name)
    instance_name.split("_").map!{|x| x.capitalize!}.join("")
  end
  private
  def gen_file(file_name,template_file_name)
    if File.exist?(file_name)
       puts "file already exists(#{file_name})!"
       return nil
    end
    con = replace_keywords(template_file_name)
    File.open(file_name,'w') do |file|
      file << con
    end
    file_name
  end
  
  def replace_keywords(template_file_name) 
    con = []
    File.open(template_file_name) do |file|
      while line = file.gets
        if line =~ /.*(\$.+\$).*/
          @keywords.each do |key,value|
            line.gsub!("$"+key.to_s+"$",value)
          end
        end
        con << line
      end
    end
    con
  end
end