# http://www.zenspider.com/Languages/Ruby/QuickRef.html#4

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "for string" do
        it "transfer to symbol" do
            "Book Author Title".gsub(/\s+/, "_").downcase.to_sym
                .must_equal(:book_author_title)
        end
    end
end