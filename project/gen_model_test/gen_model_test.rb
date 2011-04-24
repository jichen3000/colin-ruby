class GenModelTest
  def initialize(path,class_name)
    @keywords = {:class_name=>class_name, :instance_name=>class_name.downcase,
                :column_name=>'name'}
    @path = path
  end
  def gen_yaml_file()
    file_name = File.join(@path,@keywords[:instance_name]+".yml")
    template_file_name = File.join(File.dirname(__FILE__),'templatefile','yml.template')
    gen_file(file_name,template_file_name)
  end
  def gen_rb_test_file
    file_name = File.join(@path,@keywords[:instance_name]+"_test.rb")
    template_file_name = File.join(File.dirname(__FILE__),'templatefile','test.template')
    gen_file(file_name,template_file_name)
  end
  def gen_model_file
    file_name = File.join(@path,@keywords[:instance_name]+".rb")
    template_file_name = File.join(File.dirname(__FILE__),'templatefile','model.template')
    gen_file(file_name,template_file_name)
  end
  private
  def gen_file(file_name,template_file_name)
    if File.exist?(file_name)
       puts 'file already exists!'
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