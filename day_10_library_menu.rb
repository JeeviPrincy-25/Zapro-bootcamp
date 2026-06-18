require 'csv'
class BookNotFoundError < StandardError
  def initialize(title)
    super("Book not found: #{title}")
  end
end

class InvalidInputError < StandardError; end

module Displayable
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

module Searchable
    def find(query)
        @books.find do |b|
            b.title.downcase.include?(query.downcase)
        end
    end
end

module Exportable
    def to_csv_row
        fields = [title, author, year, genre]
        fields.map! do |field|
            value = field.to_s
            if value.include?(",")
                "\"#{value}\""
            else
                value
            end
        end
        fields.join(",")
    end
end

class Book
    include Exportable
    include Comparable
    include Displayable
    attr_accessor :title, :author, :year, :genre
    def initialize(title, author, year, genre)
        @title = title
        @author = author
        @year = year.to_i
        @genre = genre
    end
    def age
        Time.now.year - @year
    end
    def recent?
        age <= 5
    end
    def <=>(other)
        year <=> other.year
    end
end

class DigitalBook < Book
    attr_accessor :url
    def initialize(title, author, year, genre, url)
        super(title, author, year, genre)
        @url = url
    end
    def display
        super
        puts "URL    : #{@url}"
    end
end

class AudioBook < Book
    attr_accessor :duration_minutes
    def initialize(title, author, year, genre, duration_minutes)
        super(title, author, year, genre)
        @duration_minutes = duration_minutes.to_i
    end
    def display
        super
        hours = @duration_minutes / 60
        minutes = @duration_minutes % 60
        puts "Duration: #{hours}h #{minutes}m"
    end
end

class Library
    include Searchable
    attr_reader :books
    def all_books
        @books
    end
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
    def stats
        if @books.empty?
            return {
                total: 0,
                by_genre: {},
                average_year: 0
            }
        end
        genres = {}
        @books.each do |book|
            genres[book.genre] ||= 0
            genres[book.genre] += 1
        end
        avg_year = (@books.sum(&:year).to_f / @books.length).round
        {
            total: @books.length,
            by_genre: genres,
            average_year: avg_year
        }
    end
end

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
    puts "9. Add a Digital Book"
    puts "10. Add an Audio Book"
end

def get_validated_input(prompt, field_name, numeric_only = false, positive_only = false)
    print prompt
    input = gets.chomp.strip
    raise InvalidInputError, "#{field_name} cannot be blank." if input.empty?
    if numeric_only || positive_only
        raise InvalidInputError, "#{field_name} must be a valid number." unless input =~ /^\d+$/
        raise InvalidInputError, "#{field_name} must be a positive number greater than 0." if positive_only && input.to_i <= 0
    end
    input
end

def get_base_book_inputs
    title  = get_validated_input("Title : ", "Title")
    author = get_validated_input("Author : ", "Author")
    year   = get_validated_input("Year : ", "Year", true)
    print "Genre : "
    genre = gets.chomp.strip
    genre = "Uncategorized" if genre.empty?
    [title, author, year, genre]
end

SAVE_FILE = "books.csv"

def save_library(library)
  CSV.open(SAVE_FILE, "w") do |csv|
    csv << ["title", "author", "year", "genre", "type", "url", "duration_minutes"]
    library.all_books.each do |book|
      if book.is_a?(DigitalBook)
        csv << [book.title, book.author, book.year, book.genre, "digital", book.url, ""]
      elsif book.is_a?(AudioBook)
        csv << [book.title, book.author, book.year, book.genre, "audio", "", book.duration_minutes]
      else
        csv << [book.title, book.author, book.year, "physical", "", ""]
      end
    end
  end
  puts "Library saved."
end

def load_library(library)
  return unless File.exist?(SAVE_FILE)
  CSV.foreach(SAVE_FILE, headers: true) do |row|
    case row["type"]
    when "digital"
      library.add(DigitalBook.new(row["title"], row["author"], row["year"].to_i, row["genre"], row["url"]))
    when "audio"
      library.add(AudioBook.new(row["title"], row["author"], row["year"].to_i, row["genre"], row["duration_minutes"].to_i))
    else
      library.add(Book.new(row["title"], row["author"], row["year"].to_i, row["genre"]))
    end
  end
  puts "Loaded #{library.size} books from file."
end

library = Library.new
load_library(library)

at_exit do
  save_library(library)
end

begin
loop do
    show_menu
    print "Enter your choice : "
    ch=gets.chomp
    case ch
    when "0"
        show_spanish_menu
    when "1"
        title, author, year, genre = get_base_book_inputs
        library.add(Book.new(title, author, year, genre))
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
            raise BookNotFoundError.new(title)
        end
    when "4"
        print "Enter current title: "
        old_title = gets.chomp.strip
        new_title = get_validated_input("Enter new title: ", "Title")
        if library.update_title(old_title, new_title)
            puts "Book title updated successfully!"
        else
            raise BookNotFoundError.new(old_title)
        end
    when "5"
        print "Enter Title : "
        title=gets.chomp
        library.delete(title)
    when "6"
        save_library(library)
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
        title, author, year, genre = get_base_book_inputs
        url = get_validated_input("URL : ", "URL")
        library.add(DigitalBook.new(title, author, year, genre, url))
    when "10"
        title, author, year, genre = get_base_book_inputs
        duration = get_validated_input("Duration (minutes) : ", "Duration", false, true)
        library.add(AudioBook.new(title, author, year, genre, duration))
    else
        puts "Invalid Choice"
    end
end 
rescue BookNotFoundError => e
    puts "Error: #{e.message}"
    retry
rescue InvalidInputError => e
    puts "Invalid input: #{e.message}"
    retry
rescue Interrupt
    puts "\nGoodbye!"
ensure
    puts "Session ended."
end 