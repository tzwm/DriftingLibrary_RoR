class Book < ActiveRecord::Base
  has_many :donateds
  has_many :wishs
end
