class Book < ActiveRecord::Base
  has_many :donateds
  has_many :wishs
  has_many :book_possessions
end
