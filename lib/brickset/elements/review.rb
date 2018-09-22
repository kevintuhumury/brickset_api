module Brickset
  module Elements
    class Review
      include HappyMapper

      tag 'reviews'

      element :author, String
      element :title, String
      element :review, String
      element :date_posted, Date, tag: 'datePosted'
      element :overall_rating, Integer, tag: 'overallRating'
      element :parts, Integer
      element :building_experience, Integer, tag: 'buildingExperience'
      element :playability, Integer
      element :value_for_money, Integer, tag: 'valueForMoney'
      element :html, Boolean, tag: 'HTML'
    end
  end
end
