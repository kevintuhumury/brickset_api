module Brickset
  module Elements
    class CollectionDetail
      include HappyMapper

      tag 'collectionDetails'

      element :collection_id, Integer, tag: 'collectionID'
      element :date_acquired, String, tag: 'dateAcquired'
      element :currency, String
      element :price_paid, Float, tag: 'pricePaid'
      element :additional_price_paid, Float, tag: 'additionalPricePaid'
      element :current_estimated_value, Float, tag: 'currentEstimatedValue'
      element :condition_when_acquired, String, tag: 'conditionWhenAcquired'
      element :acquired_from, String, tag: 'acquiredFrom'
      element :condition_now, String, tag: 'conditionNow'
      element :location, String
      element :notes, String
      element :parts, Boolean
      element :minifigs, Boolean
      element :instructions, Boolean
      element :box, Boolean
      element :modified, Boolean
      element :will_trade, Boolean, tag: 'willTrade'
      element :deleted, Boolean
    end
  end
end
