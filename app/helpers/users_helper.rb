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
end
