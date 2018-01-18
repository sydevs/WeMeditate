class ArticleContent < ApplicationRecord
  has_paper_trail
  
  belongs_to :article

  enum type: [
    :text,
    :video
  ]
end
