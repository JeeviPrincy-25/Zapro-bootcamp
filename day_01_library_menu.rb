loop do
    puts "--Library Management System--"
    puts "1. Add a book"
    puts "2. List books"
    puts "3. Search for a book"
    puts "4. Update a book"
    puts "5. Delete a book"
    puts "6. Exit"
    print "Enter your choice : "
    ch=gets.chomp
    case ch
    when "1"
        puts "Add books - coming soon!"
    when "2"
        puts "List books - coming soon!"
    when "3"
        puts "Search book - coming soon!"
    when "4"
        puts "Update book - coming soon!"
    when "5"
        puts "Delete book - coming soon!"
    when "6"
        puts "Goodbye!"
        break
    else
        puts "Invalid Choice"
    end
end