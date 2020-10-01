require 'csv'
require 'ostruct'
require 'date'

def books_in_year (books_array, year)
  books_array.select { |line| line.date.include?(year) }
end

def books_without_rating (books_array)
  books_array.select {|line| line.rating.to_i.zero? }
end

def longest_books (books_array)
  books_array.sort_by { |key| -key.pages }
end

def fixing_date (books_array)
  books_array.map do |str| 
    if str[:date].length == 4
      str[:date] << " January 1st "
    elsif str[:date].length == 8
      str[:date] << " January "
    end
  end
end

def books_sorted_by_date (books_array)
  books_array.sort_by { |key| key.date.split(" ").reverse }
end

def sorted_by_month (books_array)
  books_array.map { |line| Date.parse(line[:date]) }
             .sort_by { |date| date.month }
end

def print_monthly_stats (books_array)
  books_count = Hash.new (0)
  books_array.map { |date| books_count[date.strftime("%B")] += 1 }

  books_count.map { |date, i| puts "#{date}: #{i} books" }
end

def pretty_print (books_array)
  books_array.map { |book| "#{book.title} by #{book.author} (#{book.date},#{book.pages} pages)" }.join("\n")
end

book_file = File.read("books.txt")
  .split("\n")
  .map { |line| line.split("|")}

CSV.open("output_file", "w") do |csv|
  csv << ["link", "title", "author","pages","date","rating","genre"]
  book_file.map { |books| csv << books }
end

new_book_file = CSV.read("output_file", headers:true)
                   .map { |row| OpenStruct.new(row.to_h) }
                   
fixing_date(new_book_file)
puts "books written in 1847: #{pretty_print(books_in_year(new_book_file, "1847"))}"
puts "5 longest books: #{pretty_print(books_sorted_by_date(new_book_file).first(5))}"
puts "10 novels: #{pretty_print(books_sorted_by_date(new_book_file).take(10))}"
puts "books without rating: #{pretty_print(books_without_rating(new_book_file))}"
print_monthly_stats(sorted_by_month(new_book_file))     