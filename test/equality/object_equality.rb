class Book
  attr_reader :author, :title

  def initialize(author, title)
    @author = author
    @title = title
  end

  def ==(other)
    self.class === other and
      other.author == @author and
      other.title == @title
  end

  # alias eql? ==

  # def hash
  #   @author.hash ^ @title.hash # XOR
  # end
end

book1 = Book.new 'matz', 'Ruby in a Nutshell'
book2 = Book.new 'matz', 'Ruby in a Nutshell'

p book1 == book2
p book1 === book2
p book1.equal?(book2)
p book1.eql?(book2)


# http://stackoverflow.com/questions/7156955/whats-the-difference-between-equal-eql-and
