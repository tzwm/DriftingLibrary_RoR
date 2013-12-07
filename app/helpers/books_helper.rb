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
      num += d.donated_count
    end

    return num
  end

  def stock_info(book_id)
    ret = ''
    books = BookPossession.where(:book_id=>book_id)
    books.each do |book|
      donor = User.where(:id=>book.donor).first
      holder = User.where(:id=>book.holder).first
      ret += "<tr>" + 
             "<td>" + link_to(donor.name, donor) + "</td>" +
             "<td>" + link_to(holder.name, holder) + "</td>" +
             "<td>" + book.transfer_count.to_s + "</td>" +
             "</tr>"
    end

    return ret.html_safe
  end
end
