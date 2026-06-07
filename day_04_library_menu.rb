books=[]
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
def add_book(books)
    print "Title : "
    title=gets.chomp
    print "Author : "
    author=gets.chomp
    print "Year : "
    year=gets.chomp
    print "Genre : "
    genre=gets.chomp
    genre = "Uncategorized" if genre.strip == ""

    books.push({
        title:title,author:author,year:year,genre:genre
    })
    puts "Book Added"
end

def list_first_3(books)
    puts "\nList of First 3 Books"
    books.first(3).each_with_index do |b,i|
        puts "#{i+1}. #{b[:title]} - #{b[:author]} (#{b[:year]})"
    end
end

def list_books(books)
    puts "\nList All Books"
    books.each_with_index do |b,i|
        puts "#{i+1}. #{b[:title]} - #{b[:author]} (#{b[:year]})"
    end
end

def delete_book(books)
    print "Title : "
    title=gets.chomp
    if books.reject!{|b| b[:title].downcase==title.downcase}
        puts "Book deleted"
    else
        puts "Book not found"
    end
end

def browse_by_genre(books)
    print "Enter genre : "
    g = gets.chomp.downcase

    results = books.select { |b| b[:genre].downcase == g }

    if results.empty?
        puts "No books found in that genre."
    else
        puts "\nBooks in '#{g}':"
        results.each_with_index do |b, i|
            puts "#{i+1}. #{b[:title]} - #{b[:author]} (#{b[:year]})"
        end
    end
end

def search_book(books)
    print "Enter Title : "
    t = gets.chomp.downcase

    results = books.select {|b| b[:title].downcase == t}

    if results.empty?
        puts "No books found in that Title."
    else
        puts "\nBooks in '#{t}':"
        results.each_with_index do |b, i|
            puts "#{i+1}. #{b[:title]} - #{b[:author]} (#{b[:year]})"
        end
    end
end

def books_between_years(books)
    print "Enter start year: "
    start_year = gets.chomp.to_i

    print "Enter end year: "
    end_year = gets.chomp.to_i

    if end_year < start_year
        puts "Invalid range."
        return
    end

    results = books.select { |b|
        b[:year].to_i >= start_year && b[:year].to_i <= end_year
    }

    if results.empty?
        puts "No books found in this range."
    else
        sorted = results.sort_by { |b| b[:year].to_i }

        puts "\nBooks between years:"
        sorted.each_with_index do |b, i|
            puts "#{i+1}. #{b[:title]} - #{b[:author]} (#{b[:year]})"
        end
    end
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
    puts "9. Books between years"
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
        puts "Update book - coming soon!"
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
        books_between_years(books)
    else
        puts "Invalid Choice"
    end
end