class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validate :book_availability
  validate :due_date_in_future

  private
  def book_availability
    errors.add(:book, "is already borrowed") unless book.available?
  end

  def due_date_in_future
    return if due_date.blank?
    errors.add(:due_date, "must be in the future") unless due_date > Date.current
  end

end