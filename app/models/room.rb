class Room < ApplicationRecord
    
    validates :name, presence: true
    validates :address, presence: true
    validates :price, presence: true
    validates :introduction, length: { in: 10..30 }
    validates :image, presence: true
    
    mount_uploader :image, ImageUploader
    
    has_one :reservations, dependent: :destroy
    has_many :user, through: :reservations, dependent: :destroy
    
    accepts_nested_attributes_for :reservations

end
