module BooksHelper
  def wished?(user_id, book_id)
    wishes = Wish.where(:user_id=>user_id, :book_id=>book_id)
    
    return wishes.count != 0
  end

  def wish_count(book_id)
    wishes = Wish.where(:book_id=>book_id)

    return wishes.count
  end

  def donated_total(book_id)
    donateds = Donated.where(:book_id=>book_id)
    num = 0
    donateds.each do |d|
      num += d.num
    end

    return num
  end
end
