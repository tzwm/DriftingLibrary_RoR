class DeviceController < ApplicationController
  def donate
    user = User.find_by(email:params[:session][:email].downcase)
    if user
      isbn = params[:book][:isbn]
      user_id = user.id
    @tmp = Book.where("isbn = ?",isbn)
    if @tmp.empty?
      create_book(isbn)
    else
      #flash[:error]="it has the book"
    end

    @book = Book.where(:isbn=>isbn).first
    @f_donated = Donated.where('user_id = ? and book_id = ?',user_id,@book.id)
    if @f_donated.empty?
      @donated = Donated.new
      @donated.user_id=user_id
      @donated.book_id=@book.id
      @donated.onhand_count = 1
      @donated.donated_count = 1
      if @donated.save
        #flash[:success]="add success"
      else
        #flash[:error]="add failed"
      end
    else
      @c_donated = @f_donated.first
      @c_donated.donated_count += 1
      @c_donated.onhand_count += 1
      if @c_donated.save
        flash[:success]="Add successfully,this book's total number increase 1"
      else
        flash[:error]="Don't Add successfully"
      end
    end

    n_book_possession = BookPossession.new
    n_book_possession.book_id = @book.id
    n_book_possession.donor = user_id
    n_book_possession.holder = user_id
    n_book_possession.transfer_count = 0
    n_book_possession.save

    else
    end
  end
  private
  def create_book(isbn)
    logger.info "111"
    url = "https://api.douban.com/v2/book/isbn/"+isbn.to_s+"?apikey=05fda08443dc365f11f8e18ccb94a31d&callback=?"
    logger.info "222"
    buffer = open(url, "UserAgent" => "Ruby-Wget").read
    logger.info "333"
    data = JSON.parse(buffer)
    title = data['title']
    sub_title=data['sub_title']
    author=data['author'][0]
    author_intro=data['author_intro']
    image=data['image']
    summary=data['summary']
    summary="<p>"+summary+"</p>";
    summary=summary.gsub(/\n/,"</p>\n<p>")
    publisher=data['publisher']
    pubdate=data['pubdate']
    book_url =data['alt'];
    tags = data['tags']
    tag = ""
    tags.each do |subject|
      tag = tag+subject['name']+","
    end
    tag = tag[0,tag.length-1]

    book = Book.new
    book.title=title
    book.subtitle=sub_title
    book.author=author
    book.author_infor=author_intro
    book.image= image
    book.summary=summary
    book.publisher=publisher
    book.pubdate=pubdate
    book.num=1
    book.isbn=isbn
    book.url=book_url
    book.tag = tag
    book.save
    book
  end

end
