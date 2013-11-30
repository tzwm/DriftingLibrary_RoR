require 'json'
require 'open-uri'

class BooksController < ApplicationController
	before_action :signed_in_user,only: [:donate]
	def donate
		isbn = params[:book][:isbn]
		url = "https://api.douban.com/v2/book/isbn/"+isbn+"?apikey=05fda08443dc365f11f8e18ccb94a31d&callback=?"
		# resp = Net::HTTP.get_response(URI.parse(url))
		# data = resp.body
		# logger.info(data)
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
		user_id = @current_user.id
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
		@book.user_id=user_id
		@book.tag = tag
		if @book.save
			flash[:success]="add success"
		else
			flash[:error]="add failed"
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
