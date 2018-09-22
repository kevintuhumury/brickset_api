module Brickset
  module Elements
    class AdditionalImage
      include HappyMapper

      tag 'additionalImages'

      element :thumbnail_url, String, tag: 'thumbnailURL'
      element :thumbnail_url_large, String, tag: 'largeThumbnailURL'
      element :image_url, String, tag: 'imageURL'
    end
  end
end
