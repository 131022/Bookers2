class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save

      flash[:notice] = "successfully saved"
      redirect_to book_path(@book)
    else
      @books = Book.all.order(:id)
      render action: :index
    end
  end

  def edit
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      redirect_to user_path(current_user)
      return
    end
  end

  def update
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      redirect_to user_path(current_user)
      return
    end

    if @user.update(user_params)
      flash[:notice] = "successfully updated"
      redirect_to user_path(@user)
    else
      render action: :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
