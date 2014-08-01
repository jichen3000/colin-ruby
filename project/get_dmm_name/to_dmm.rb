# encoding: utf-8
require 'opendmm'

class DmmName
    def self.is_need_handle(the_path)
        return false if not the_path
        extname = File.extname(the_path)
        basename = File.basename(the_path, extname)
        reg = /(\S+-\d+)(.?)/
        if basename =~ reg
            # pp $2, $1
            if $2.empty?
                return basename
            end
        end
        false
    end

    def self.get_all_movie_files(the_path)
        Dir[File.join(the_path,"**/*.{rmvb,avi,mp4,wmv}")]
    end

    def self.get_title_actresses(company_and_no)
        return nil if not company_and_no
        dmm_info = OpenDMM.search(company_and_no)
        return nil if not dmm_info
        if dmm_info[:actresses]
            dmm_info[:title][0..20]+"_"+dmm_info[:actresses].join("_")
        else
            dmm_info[:title][0..30]
        end
    end

    def self.transfer_all(the_path)
        self.get_all_movie_files(the_path).each do |movie_path|
            basename = File.basename(movie_path)
            company_and_no = self.is_need_handle(movie_path)
            next if not company_and_no
            puts("Processing file #{basename}")
            title_actresses = self.get_title_actresses(company_and_no)
            if title_actresses
                file_name = company_and_no+"_"+title_actresses
                new_path = File.join(File.dirname(movie_path), 
                    file_name+File.extname(movie_path))
                File.rename(movie_path, new_path)
                puts("Move file #{basename} to #{new_path}")
            else
                puts("Cannot get info of the file #{basename}")
            end
        end
    end
end

if __FILE__ == $0
    require 'pp'

    def main()
        if ARGV.size > 0
            DmmName.transfer_all(ARGV[0])
        else
            puts("Usage: ruby #{$0} /movie/file/path")
        end
        # the_path
        # self.transfer_all(the_path)
    end
    main()

    # require 'minitest/spec'
    # require 'minitest/autorun'
    # describe DmmName do
    #     it 'can to name' do
    #         file_path = '/usr/colin/00t4/ABP-082.rmvb'
    #         DmmName.is_need_handle(file_path).must_equal('ABP-082')
    #         file_path = '/Volumes/ColinPortable/ora/00t4/ABP-154最高のセックス。-DVD-あやみ-旬果.rmvb'
    #         DmmName.is_need_handle(file_path).must_equal(false)
    #     end
    #     it 'can get all files from a dir' do
    #         DmmName.get_all_movie_files('/Volumes/ColinPortable/ora/im5@NANP-004/')
    #     end
    #     it 'can get dmm name' do
    #         # pp DmmName.get_title_actresses('ABP-082')
    #     end
    # end
end