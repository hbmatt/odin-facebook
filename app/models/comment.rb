class Comment < ApplicationRecord
  belongs_to :author, class: 'User'
  belongs_to :post
end
