module WelcomeHelper
  def five_random_books_image_tag
    ret = ""
    5.times do
      randomID = Random.rand(Book.count) + 1
      book = Book.find(randomID)
      imgUrl = book.image
      title = book.title
      ret += link_to(image_tag(imgUrl, alt: title, class: "img_cover"), 
                     book_path(book)) + "\n"
    end
    
    return ret.html_safe
  end
end
