def create_book_hash(book_array)
  {
    link: book_array[0],
    title: book_array[1],
    author: book_array[2],
    pages: book_array[3].to_i,
    date: book_array[4],
    rating: book_array[5].to_f,
    genre: book_array[6]
  }
end

def books_in_year (books_array, year)
  books_array.select { |line| line[:date].include?(year)}
end

def books_without_rating (books_array)
  books_array.select {|line| line[:rating].zero? }
end

def longest_books (books_array)
  books_array.sort_by { |key| -key[:pages]}
end

def books_sorted_by_authors (books_array)
  books_array.sort_by { |key| key[:author].split.last}
             .uniq {|hash| hash.values_at(:author)}
end

def books_sorted_by_date (books_array)
  books_array.sort_by { |key| key[:date].split(" ").reverse }
end

def pretty_print (books_array)
  books_array.map { |book| "#{book[:title]} by #{book[:author]} (#{book[:date]},#{book[:pages]} pages)" }.join("\n")
end

book_file = File.read("books.txt")
  .split("\n")
  .map { |line| line.split("|")}
  .map { |book_array| create_book_hash(book_array)}
  
puts "authors alphabetically: #{pretty_print(books_sorted_by_authors(book_file))}"
puts "books written in 1847: #{pretty_print(books_in_year(book_file, "1847"))}"
puts "5 longest books: #{pretty_print(books_sorted_by_date(book_file).first(5))}"
puts "10 novels: #{pretty_print(books_sorted_by_date(book_file).take(10))}"
puts "books without rating: #{pretty_print(books_without_rating(book_file))}"

