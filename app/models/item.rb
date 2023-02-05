class Item < ApplicationRecord
  has_one_attached :image
  
  belongs_to :customer
  belongs_to :genre, optional: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  validates :name, presence: true
  validates :category, presence: true
  validates :body, presence: true
  
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
  
  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end
  
end
