class BooksController < ApplicationController
	before_action :signed_in_user,only: [:donate]
	def donate
		flash[:success]="success"
		redirect_to @current_user
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
