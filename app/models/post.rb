class Post < ApplicationRecord
  belongs_to :author, class: 'User'
  has_many :comments, dependent: :destroy
end
