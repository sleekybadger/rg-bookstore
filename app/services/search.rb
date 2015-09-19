class Search
  attr_reader :results

  def initialize(query, search_by = 'books')
    @query = query
    @search_by = search_by
    @results = []
  end

  def search
    case @search_by
      when 'books'
        search_books
      when 'authors'
        search_authors
      else
    end

    self
  end

  private

  def search_books
    @results = Book.search(@query)
  end

  def search_authors
    @results = Author.search(@query)
  end
end