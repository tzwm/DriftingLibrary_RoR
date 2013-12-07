require 'json'
require 'open-uri'

class BooksController < ApplicationController
  before_action :signed_in_user,only: [:donate]

  def search
    isbn = params[:search][:isbn]
    
    tmp = Book.where(:isbn=>isbn.to_s)
    if tmp.empty?
      book = create_book(isbn)
      redirect_to book
    else
      redirect_to tmp.first
    end
  end

  def donate
    isbn = params[:book][:isbn]
    user_id = @current_user.id
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

    redirect_to @current_user
  end

  def show
    @book = Book.find(params[:id])
  end

  def wish
    n_wish = Wish.new
    n_wish.user_id = params[:u]
    n_wish.book_id = params[:id]
    if n_wish.save
      flash[:success] = "成功添加想借书籍"
    else
      flash[:error] = "添加失败"
    end

    redirect_to Book.find(params[:id])
  end

  def cancel_wish
    if Wish.destroy_all(:user_id=>params[:u],
                        :book_id=>params[:id])
      flash[:success] = "成功移除想借书籍"
    else
      flash[:error] = "移除失败"
    end

    redirect_to Book.find(params[:id])
  end

  def donate_again
    user_id = params[:u]
    book_id = params[:id]
    o_donate = Donated.where(:user_id=>user_id,
                             :book_id=>book_id)
    if o_donate.empty?
      n_donate = Donated.new(:user_id=>user_id,
                             :book_id=>book_id,
                             :donated_count=>1,
                             :onhand_count=>1)
      n_donate.save
    else
      n_donate = o_donate.first
      n_donate.donated_count += 1
      n_donate.onhand_count += 1
      n_donate.save
    end

    n_book_possession = BookPossession.new
    n_book_possession.book_id = book_id
    n_book_possession.donor = user_id
    n_book_possession.holder = user_id
    n_book_possession.transfer_count = 0
    n_book_possession.save

    flash[:success] = "成功捐赠"

    redirect_to Book.find(params[:id])
  end

  private
  def signed_in_user
    unless signed_in?
      store_location
      flash[:notice] = "Please sign in."
      redirect_to signin_url
    end
  end

  private
  def create_book(isbn)
    url = "https://api.douban.com/v2/book/isbn/"+isbn.to_s+"?apikey=05fda08443dc365f11f8e18ccb94a31d&callback=?"
    buffer = open(url, "UserAgent" => "Ruby-Wget").read
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
