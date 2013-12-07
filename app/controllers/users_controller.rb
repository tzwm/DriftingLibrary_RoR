class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user= User.find(params[:id])
    @donateds = Donated.where(:user_id=>params[:id])
    @d_count =0
    @donateds.each do |book|
      @d_count = @d_count+book.donated_count
    end
    @b_books = Borrowed.where(:user_id=>params[:id])
    @b_count = 0
    @b_books.each do |book|
      @b_count = @b_count+book.num
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      sign_in @user
      flash[:success] = "Register successful"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def request_list
    @user= User.find(params[:id])
    @donateds = Donated.where(:user_id=>params[:id])
    @d_count =0
    @donateds.each do |book|
      @d_count = @d_count+book.donated_count
    end
    @b_books = Borrowed.where(:user_id=>params[:id])
    @b_count = 0
    @b_books.each do |book|
      @b_count = @b_count+book.num
    end

    render 'request_list'
  end

  def send_book
    user_id = params[:id]
    book_id = params[:book]
    receiver_id = params[:receiver]

    Wish.where(user_id: receiver_id, book_id: book_id).first.destroy

    donated = Donated.where(user_id: user_id, book_id: book_id).first 
    donated.onhand_count -= 1
    donated.save

    bp = BookPossession.where(book_id: book_id, holder: user_id).first
    bp.status = "sending"
    bp.save
    
    pending = PendingBook.new
    pending.book_possession_id = bp.id
    pending.sender_id = user_id
    pending.receiver_id = receiver_id
    pending.status = "sending"
    pending.save 

    redirect_to 'request_list'
  end

  def pending_list
    @user= User.find(params[:id])
    @donateds = Donated.where(:user_id=>params[:id])
    @d_count =0
    @donateds.each do |book|
      @d_count = @d_count+book.donated_count
    end
    @b_books = Borrowed.where(:user_id=>params[:id])
    @b_count = 0
    @b_books.each do |book|
      @b_count = @b_count+book.num
    end

    render 'pending_list'
  end

  def confirm_book

  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def signed_in_user
    unless signed_in?
      store_location
      flash[:notice] = "Please sign in."
      redirect_to signin_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

end
