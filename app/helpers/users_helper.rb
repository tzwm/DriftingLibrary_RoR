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
        continue
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
               "<td>" + link_to("借出", '#') + "</td>" +
               "</tr>"
      end
    end

    return ret.html_safe
  end
end
