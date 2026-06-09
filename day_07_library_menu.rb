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
  def age
    Time.now.year - @year
  end
  def recent?
    age <= 5
  end
  def to_s
    "#{@title} by #{@author} (#{@year})"
  end
end

class Library
    attr_reader :books
    def initialize
        @books = []
    end
    def add(book)
        @books.push(book)
        puts "Book Added"
    end
    def list(limit = nil)
        collection = limit ? @books.first(limit) : @books
        collection.each do |book|
            book.display
        end
    end
    def find(query)
        @books.find do |b|
            b.title.downcase.include?(query.downcase)
        end
    end
    def delete(title)
        before = @books.length
        @books.reject! { |b| b.title.downcase == title.downcase }
        @books.length < before ? puts("Deleted.") : puts("Not found.")
    end
    def books_by_genre(genre)
        @books.select do |b|
            b.genre.downcase == genre.downcase
        end
    end
    def size
        @books.length
    end
    def update_title(old_title, new_title)
        book = find(old_title)
        if book
            book.title = new_title
            true
        else
            false
        end
    end
    def summary
        if @books.empty?
            puts "No Book in the Library"
            return
        end
        tot = @books.length
        recent = @books.last
        old = @books.min_by(&:year)
        auth = @books.map(&:author).uniq
        after_2000 = @books.count { |b| b.year > 2000 }
        puts "--Library Summary--"
        puts "Total Books : #{tot}"
        puts "Most Recent Book : #{recent}"
        puts "Oldest Book : #{old}"
        puts "Unique Authors : #{auth}"
        puts "Books After 2000 : #{after_2000}"
    end
end

library = Library.new

def show_spanish_menu
  puts "\n-- Sistema de Gestion de Biblioteca --"
  puts "1. Agregar un libro"
  puts "2. Listar libros"
  puts "3. Buscar un libro"
  puts "4. Actualizar un libro"
  puts "5. Eliminar un libro"
  puts "6. Salir"

  puts "\nPress Enter to return to the main menu"
  gets
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
    puts "0. Spanish Menu"
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
        library.add(Book.new(title,author,year,genre))
    when "2"
        puts "First 3 Books"
        library.list(3)
    when "3"
        print "Enter Title : "
        title = gets.chomp
        book = library.find(title)
        if book
            book.display
        else
            puts "No book found."
        end
    when "4"
        print "Enter current title: "
        old_title = gets.chomp.strip
        print "Enter new title: "
        new_title = gets.chomp.strip
        return unless validate_input(new_title, "Title")
        if library.update_title(old_title, new_title)
            puts "Book title updated successfully!"
        else
            puts "No book found with that title."
        end
    when "5"
        print "Enter Title : "
        title=gets.chomp
        library.delete(title)
    when "6"
        puts "Goodbye!"
        break
    when "7"
        library.list
    when "8"
        print "Enter Genre : "
        genre = gets.chomp
        books = library.books_by_genre(genre)
        if books.empty?
            puts "No books found."
        else
            books.each do |book|
                book.display
            end
        end
    when "9"
        library.summary
    else
        puts "Invalid Choice"
    end
end