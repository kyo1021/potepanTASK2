class Reservation < ApplicationRecord
    
    validates :start_date, presence: true
    validates :last_date, presence: true
    validates :people, presence: true
    
    belongs_to :user, optional: true, foreign_key: true
    belongs_to :room, optional: true, foreign_key: true
    
end
