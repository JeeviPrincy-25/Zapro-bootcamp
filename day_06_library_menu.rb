class Book
  attr_accessor :title, :author, :year, :genre
  def initialize(title, author, year, genre)
    @title = title
    @author = author
    @year = year.to_i
    @genre = genre
  end
  def display
    puts "Title  : #{@title}"
    puts "Author : #{@author}"
    puts "Year   : #{@year}"
    puts "Genre  : #{@genre}"
  end
  def to_s
    "#{@title} by #{@author} (#{@year})"
  end
end

books=[]
def update_book_title(books)
    print "Enter current title: "
    old_title = gets.chomp.strip

    book = books.find { |b|
        b.title.downcase == old_title.downcase
    }

    if book.nil?
        puts "No book found with that title."
        return
    end

    print "Enter new title: "
    new_title = gets.chomp.strip

    return unless validate_input(new_title, "Title")

    puts "\nRename '#{book.title}' -> '#{new_title}'? (y/n)"
    confirm = gets.chomp.downcase

    if confirm == "y"
        book.title = new_title
        puts "Book title updated successfully!"
    else
        puts "Update cancelled."
    end
end

def add_book(books)
    print "Title : "
    title=gets.chomp
    return unless validate_input(title, "Title")
    print "Author : "
    author=gets.chomp
    return unless validate_input(author, "Author")
    print "Year : "
    year=gets.chomp
    return unless validate_input(year, "Year")
    print "Genre : "
    genre=gets.chomp
    genre = "Uncategorized" if genre.strip == ""

    books.push(
        Book.new(title,author,year,genre)
    )
    puts "Book Added"
end

def list_first_3(books)
    puts "\nList of First 3 Books"
    books.first(3).each do |b|
        b.display
    end
end

def list_books(books)
    puts "\nList All Books"
    books.each do |b|
        b.display
    end
end

def delete_book(books)
    print "Title : "
    title=gets.chomp
    if books.reject!{|b| b.title.downcase==title.downcase}
        puts "Book deleted"
    else
        puts "Book not found"
    end
end

def browse_by_genre(books)
    print "Enter genre : "
    g = gets.chomp.downcase

    results = books.select { |b| b.genre.downcase == g }

    if results.empty?
        puts "No books found in that genre."
    else
        puts "\nBooks in '#{g}':"
        results.each do |b|
            b.display
        end
    end
end

def search_book(books)
    print "Enter Title : "
    t = gets.chomp.strip

    book = books.find { |b|
        b.title.downcase == t.downcase
    }

    if book
        book.display
    else
        puts "No books found in that Title."
    end
end

def book_summary(books)
    if books.empty?
        puts "No Book in the Library"
        return
    else
        tot=books.length
        recent=books.last
        old=books.min_by{|b| b.year}
        auth=books.map{|b| b.author}.uniq
        after_2000=books.count{|b| b.year>2000}
        puts "--Library Summary--"
        puts "Total Books : #{tot}"
        puts "Most Recent Book : #{recent}"
        puts "Oldest Book : #{old}"
        puts "Unique Authors : #{auth}"
        puts "Books After 2000 : #{after_2000}"
    end
end

def validate_input(value, field_name)
    if value.strip.empty?
        puts "#{field_name} cannot be blank."
        return false
    end
    true
end

def show_menu
    puts "--Library Management System--"
    puts "1. Add a book"
    puts "2. List First 3 books"
    puts "3. Search for a book"
    puts "4. Update a book"
    puts "5. Delete a book"
    puts "6. Exit"
    puts "7. List All Books"
    puts "8. Browse by Genre"
    puts "9. Library Summary"
end

loop do
    show_menu
    print "Enter your choice : "
    ch=gets.chomp
    case ch
    when "0"
        show_spanish_menu
    when "1"
        add_book(books)
    when "2"
        list_first_3(books)
    when "3"
        search_book(books)
    when "4"
        update_book_title(books)
    when "5"
        delete_book(books)
    when "6"
        puts "Goodbye!"
        break
    when "7"
        list_books(books)
    when "8"
        browse_by_genre(books)
    when "9"
        book_summary(books)
    else
        puts "Invalid Choice"
    end
end