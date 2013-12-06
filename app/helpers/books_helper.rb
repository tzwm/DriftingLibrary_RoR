module BooksHelper
  def wished?(user_id, book_id)
    wishes = Wish.where(:user_id=>user_id, :book_id=>book_id)
    
    return wishes.count != 0
  end

  def wish_count(book_id)
    wishes = Wish.where(:book_id=>book_id)

    return wishes.count
  end
end
