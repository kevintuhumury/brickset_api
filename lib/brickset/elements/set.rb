module Brickset
  module Elements
    class Set
      include HappyMapper

      tag 'sets'

      element :id, Integer, tag: 'setID'
      element :number, String
      element :number_variant, Integer, tag: 'numberVariant'
      element :name, String
      element :year, String
      element :description, String
      element :category, String
      element :theme, String
      element :theme_group, String, tag: 'themeGroup'
      element :subtheme, String, tag: 'subtheme'
      element :pieces, String
      element :minifigs, String
      element :image, Boolean
      element :image_url, String, tag: 'imageURL'
      element :image_filename, String, tag: 'imageFilename'
      element :thumbnail_url, String, tag: 'thumbnailURL'
      element :thumbnail_url_large, String, tag: 'largeThumbnailURL'
      element :brickset_url, String, tag: 'bricksetURL'
      element :owned_by_total, Integer, tag: 'ownedByTotal'
      element :wanted_by_total, Integer, tag: 'wantedByTotal'
      element :released, Boolean
      element :rating, Float
      element :user_rating, Integer, tag: 'userRating'
      element :review_count, Integer, tag: 'reviewCount'
      element :instructions_count, Integer, tag: 'instructionsCount'
      element :additional_image_count, Integer, tag: 'additionalImageCount'
      element :last_updated, Date, tag: 'lastUpdated'
      element :age_minimum, Integer, tag: 'ageMin'
      element :age_maximum, Integer, tag: 'ageMax'
      element :notes, String
      element :tags, String

      # retail related.

      element :retail_price_uk, String, tag: 'UKRetailPrice'
      element :retail_price_us, String, tag: 'USRetailPrice'
      element :retail_price_ca, String, tag: 'CARetailPrice'
      element :retail_price_eu, String, tag: 'EURetailPrice'
      element :date_added_to_shop, String, tag: 'USDateAddedToSAH'
      element :date_removed_from_shop, String, tag: 'USDateRemovedFromSAH'
      element :packaging_type, String, tag: 'packagingType'
      element :height, Float
      element :width, Float
      element :depth, Float
      element :weight, Float
      element :availability, String
      element :ean, String, tag: 'EAN'
      element :upc, String, tag: 'UPC'

      element :acm_data_count, Integer, tag: 'ACMDataCount'

      # requires authentication.

      element :owned, Boolean
      element :wanted, Boolean
      element :number_owned, Integer, tag: 'qtyOwned'
      element :user_notes, String, tag: 'userNotes'
    end
  end
end
