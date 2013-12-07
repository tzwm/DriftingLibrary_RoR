module UsersHelper
  def gravatar_for(id)
    @current=User.find(id);
    gravatar_id = Digest::MD5::hexdigest(@current.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: @current.name, class: "user_photo")
  end

  def name_for(id)
    @current=User.find(id);
    @current.name
  end

  def last_book
    if Book.count >= 2
      book = Book.last
      book2 = Book.find(Book.count-1)
      return link_to(image_tag(book.image), book) +
             link_to(image_tag(book2.image, style: 'float:right'), book2)
    end

    if Book.count >= 1
      book = Book.last
      return link_to(image_tag(book.image), book)
    end

    return ''
  end

  def get_wish_books(id)
    num = 0
    ret = ''
    tmp = ''

    @wishes = Wish.where(:user_id=>id)
    @wishes.each do |wish|
      book = wish.book
      num += 1
      if num==6
        num=1
        ret += "<li>"+tmp+"</li>\n"
        tmp = ''
      else
        tmp += link_to(image_tag(book.image, 
                                 alt:book.title, 
                                 class:"img_cover"),
                       book_path(book)) + "\n"
      end
    end
    if tmp!=''
      ret += "<li>"+tmp+"</li>\n"
    end

    return ret.html_safe
  end

  def get_onhand_books(user_id)
    num = 0
    ret = ''
    tmp = ''

    donateds = Donated.where(user_id: user_id)
    donateds.each do |d|
      if d.onhand_count == 0
        next
      end

      book = d.book
      num += 1
      if num == 6
        num = 1
        ret += "<li>"+tmp+"</li>\n"
        tmp = ''
      else
        tmp += link_to(image_tag(book.image,
                                 alt:book.title,
                                 class: "img_cover"),
                       book) + "\n"
      end
    end

    borroweds = Borrowed.where(user_id: user_id)
    borroweds.each do |b|
      if b.num == 0
        next
      end

      book = Book.find(b.book_id)
      num += 1
      if num == 6
        num = 1
        ret += "<li>"+tmp+"</li>\n"
        tmp = ''
      else
        tmp += link_to(image_tag(book.image,
                                 alt:book.title,
                                 class: "img_cover"),
                       book) + "\n"
      end
    end
    if tmp!=''
      ret += "<li>"+tmp+"</li>\n"
    end

    return ret.html_safe
  end

  def get_donated_books
    num = 0
    ret = ''
    tmp = ''

    @donateds.each do |donated|
      book = donated.book
      num += 1
      if num==6
        num=1
        ret += "<li>"+tmp+"</li>\n"
        tmp = ''
      else
        tmp += link_to(image_tag(book.image, 
                                 alt:book.title, 
                                 class:"img_cover"),
                       book_path(book)) + "\n"
      end
    end
    if tmp!=''
      ret += "<li>"+tmp+"</li>\n"
    end

    return ret.html_safe
  end

  def get_request_list(user_id)
    ret = ""

    donateds = Donated.where(user_id: user_id)
    donateds.each do |d|
      if d.onhand_count == 0
        next
      end

      book = Book.find(d.book_id)
      wishes = Wish.where(book_id: d.book_id)
      wishes.each do |w|
        ret += "<tr>" +
               "<td>" + 
                        image_tag(book.image, class: 'img_cover') + 
                        link_to(book.title, book, class: 'title') + 
               "</td>" +
               "<td>" + link_to(User.find(w.user_id).name, User.find(w.user_id)) + "</td>" +
               "<td>" + d.updated_at.to_s.split(' ')[0] + "</td>" +
               "<td>" + link_to("借出", 
                                {controller: 'users', 
                                 action: 'send_book', 
                                 receiver: w.user_id, 
                                 book: book.id }, 
                                method: 'post') + 
               "</td>" +
               "</tr>"
      end
    end

    borroweds = Borrowed.where(user_id: user_id)
    borroweds.each do |b|
      if b.num == 0
        next
      end

      book = Book.find(b.book_id)
      wishes = Wish.where(book_id: b.book_id)
      wishes.each do |w|
        ret += "<tr>" +
               "<td>" + 
                        image_tag(book.image, class: 'img_cover') + 
                        link_to(book.title, book, class: 'title') + 
               "</td>" +
               "<td>" + link_to(User.find(w.user_id).name, User.find(w.user_id)) + "</td>" +
               "<td>" + d.updated_at.to_s.split(' ')[0] + "</td>" +
               "<td>" + link_to("借出", 
                                {controller: 'users', 
                                 action: 'send_book', 
                                 receiver: w.user_id, 
                                 book: book.id }, 
                                method: 'post') + 
               "</td>" +
               "</tr>"
      end
    end


    return ret.html_safe
  end

  def get_pending_list(user_id)
    ret = ""

    pbs = PendingBook.where(receiver_id: user_id,
                            status: "sending")
    pbs.each do |pb|
      book = Book.find(BookPossession.find(pb.book_possession_id).book_id)
      ret += "<tr>" +
             "<td>" +
                      image_tag(book.image, class: 'img_cover') + 
                      link_to(book.title, book, class: 'title') + 
             "</td>" +
             "<td>" + link_to(User.find(pb.sender_id).name, User.find(pb.sender_id)) + "</td>" +
             "<td>" + link_to(User.find(pb.receiver_id).name, User.find(pb.receiver_id)) + "</td>" +
             "<td>" + pb.updated_at.to_s.split(' ')[0] + "</td>" + 
             "<td>" + link_to("确认收到", 
                              {controller: 'users',
                               action: 'confirm_book',
                               book: book.id,
                               sender: pb.sender_id},
                              method: 'post') + 
             "</td>" + 
             "</tr>"
    end 

    pbs = PendingBook.where(sender_id: user_id,
                            status: "sending")
    pbs.each do |pb|
      book = Book.find(BookPossession.find(pb.book_possession_id).book_id)
      ret += "<tr>" +
             "<td>" +
                      image_tag(book.image, class: 'img_cover') + 
                      link_to(book.title, book, class: 'title') + 
             "</td>" +
             "<td>" + link_to(User.find(pb.sender_id).name, User.find(pb.sender_id)) + "</td>" +
             "<td>" + link_to(User.find(pb.receiver_id).name, User.find(pb.receiver_id)) + "</td>" +
             "<td>" + pb.updated_at.to_s.split(' ')[0] + "</td>" + 
             "<td>" + "等待对方确认" + "</td>"
             "</tr>"
    end 

    return ret.html_safe
  end
end

