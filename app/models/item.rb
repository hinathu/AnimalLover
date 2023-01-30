class Item < ApplicationRecord
  has_one_attached :image
  
  belongs_to :customer
  belongs_to :genre
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  def get_image
    if image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    else
      image
    end
  end
  
end
