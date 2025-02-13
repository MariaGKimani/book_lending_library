class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author, :isbn, :available)
    end
    def borrow
      @book = Book.find(params[:id])
      @borrowing = current_user.borrowings.build(
        book: @book,
        borrowed_at: Time.current,
        due_date: 2.weeks.from_now
      )
      
      if @borrowing.save
        @book.update(available: false)
        redirect_to profile_path
      else
        redirect_to @book, alert: "Could not borrow book"
      end
    end
    
    def return
      @book = Book.find(params[:id])
      borrowing = @book.borrowings.where(user: current_user).pending.first
      if borrowing&.update(returned_at: Time.current)
        @book.update(available: true)
        redirect_to profile_path
      else
        redirect_to profile_path, alert: "Return failed"
      end
    end
end


