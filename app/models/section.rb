class Section < ApplicationRecord
  has_paper_trail
  
  belongs_to :article

  enum content_type: [
    :text,
    :video
  ]
end
