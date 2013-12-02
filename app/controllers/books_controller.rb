require 'json'
require 'open-uri'

class BooksController < ApplicationController
	before_action :signed_in_user,only: [:donate]
	def donate
		isbn = params[:book][:isbn]
		user_id = @current_user.id
		@tmp = Book.where("isbn = ?",isbn)
		if @tmp.empty?
			url = "https://api.douban.com/v2/book/isbn/"+isbn+"?apikey=05fda08443dc365f11f8e18ccb94a31d&callback=?"
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
			@book = Book.new
			@book.title=title
			@book.subtitle=sub_title
			@book.author=author
			@book.author_infor=author_intro
			@book.image= image
			@book.summary=summary
			@book.publisher=publisher
			@book.pubdate=pubdate
			@book.num=1
			@book.isbn=isbn
			@book.url=book_url
			@book.tag = tag
			if @book.save
				#flash[:success]="add success"
			else
				#flash[:error]="add failed"
			end
		else
			#flash[:error]="it has the book"
		end

		@book = Book.where(:isbn=>isbn).first
		@f_donated = Donated.where('user_id = ? and book_id = ?',user_id,@book.id)
		if @f_donated.empty?
			@donated = Donated.new
			@donated.user_id=user_id
			@donated.book_id=@book.id
			@donated.num = 1
			if @donated.save
				#flash[:success]="add success"
			else
				#flash[:error]="add failed"
			end
		else
		@c_donated = @f_donated.first
		@c_donated.num = @c_donated.num+1
		if @c_donated.save
			flash[:success]="Add successfully,this book's total number increase 1"
		else
			flash[:error]="Don't Add successfully"
		end

	end
	redirect_to @current_user
end

def show
	@book = Book.find(params[:id])
end
private
def signed_in_user
	unless signed_in?
		store_location
		flash[:notice] = "Please sign in."
		redirect_to signin_url
	end
end
end
