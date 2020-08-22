class Post < ApplicationRecord
  belongs_to :author, class: 'User'
end
