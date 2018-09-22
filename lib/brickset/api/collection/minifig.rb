module Brickset
  module Api
    module Collection
      module Minifig
        extend ActiveSupport::Concern

        included do
          attr_accessor :minifig_number, :number_owned, :wanted

          with_options(on: :update_minifig_collection) do |options|
            options.validates :minifig_number, :number_owned, :wanted, presence: true
            options.validates :number_owned, inclusion: { in: (0..999) }
            options.validates :wanted, inclusion: { in: [0, 1] }
          end
        end

        def minifig_collection(query: '', owned: '', wanted: '')
          xml = call('/getMinifigCollection', query: query, owned: owned, wanted: wanted)
          Brickset::Elements::MinifigCollection.parse xml
        end

        def update_minifig_collection(options)
          extract_attributes_from_options(options)

          if valid?(:update_minifig_collection)
            handle_update call('/setMinifigCollection', minifigNumber: minifig_number, qtyOwned: number_owned, wanted: wanted)
          else
            raise ValidationError, self.errors.full_messages.to_sentence
          end
        end

      end
    end
  end
end
