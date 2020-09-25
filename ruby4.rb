require 'csv'


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

CSV.open("output_file", "w") do |csv|
  csv << ["link", "title", "author","pages","date","rating","genre"]
  book_file.map { |books| csv << books }
end

new_book_file = CSV.read("output_file", headers:true)
  
puts "authors alphabetically: #{pretty_print(books_sorted_by_authors(book_file))}"
puts "books written in 1847: #{pretty_print(books_in_year(book_file, "1847"))}"
puts "5 longest books: #{pretty_print(books_sorted_by_date(book_file).first(5))}"
puts "10 novels: #{pretty_print(books_sorted_by_date(book_file).take(10))}"
puts "books without rating: #{pretty_print(books_without_rating(book_file))}"