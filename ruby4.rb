require 'csv'
require 'ostruct'
require 'date'

def create_book_hash(book_array)
  {
    link: book_array[0],
    title: book_array[1],
    author: book_array[2],
    pages: book_array[3].to_i,
    date: fix_date(book_array[4]),
    rating: book_array[5].to_f,
    genre: book_array[6]
  }
end

def books_in_year (books_array, year)
  books_array.select { |line| line[:date].year == year }
end

def books_without_rating (books_array)
  books_array.select { |line| line[:rating].zero? }
end

def longest_books (books_array)
  books_array.sort_by { |key| -key[:pages] }
end

def fix_date (date_str)
     if date_str.length == 4
      date_str << " January 1st "
    elsif date_str.length == 8
      date_str << " January "
    end
    Date.parse(date_str)
end

def books_sorted_by_date (books_array)
  books_array.sort_by { |key| key[:date] }
end

def sorted_by_month (books_array)
  books_array.sort_by { |line| line[:date].month }
end

def count_monthly_stats (books_array)
  books_count = Hash.new (0)
  books_array.map { |line| books_count[Date::MONTHNAMES[line[:date].month]] += 1 }

  books_count.inspect
end

def pretty_print (books_array)
  books_array.map { |book| "#{book.title} by #{book.author} (#{book.date}, #{book.pages} pages)" }
end

book_file = CSV.new(File.read("books.txt"), row_sep: "\n", col_sep: "|" )
               .map { |books| OpenStruct.new(create_book_hash(books)) }
                   
puts "books written in 1847: #{pretty_print(books_in_year(book_file, 1847))}"
puts "5 longest books: #{pretty_print(books_sorted_by_date(book_file).first(5))}"
puts "10 novels: #{pretty_print(books_sorted_by_date(book_file).take(10))}"
puts "books without rating: #{pretty_print(books_without_rating(book_file))}"
puts "monthly statistics: #{count_monthly_stats(sorted_by_month(book_file))}"     