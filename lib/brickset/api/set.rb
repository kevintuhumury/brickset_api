module Brickset
  module Api
    module Set
      extend ActiveSupport::Concern

      module Order
        module Types
          NUMBER          = 'number'
          NAME            = 'name'
          THEME           = 'theme'
          PIECES          = 'pieces'
          RATING          = 'rating'
          SUBTHEME        = 'subtheme'
          MINIFIGS        = 'minifigs'
          YEAR_FROM       = 'yearfrom'
          RETAIL_PRICE_UK = 'ukretailprice'
          RETAIL_PRICE_US = 'usretailprice'
          RETAIL_PRICE_CA = 'caretailprice'
          RETAIL_PRICE_EU = 'euretailprice'
          RANDOM          = 'random'
          ALL             = constants(false).map { |constant| const_get(constant) }
        end

        module Direction
          ASC             = 'asc'
          DESC            = 'desc'
          ALL             = constants(false).map { |constant| const_get(constant) }
        end
      end

      included do
        attr_accessor :set_number, :year, :page_size, :page_number, :order_by, :order_direction, :set_id, :minutes_ago

        with_options(on: :sets) do |options|
          options.validates :set_number, format: { with: /\A\w+-\d+\z/, message: 'format of <number>-<variant>, e.g. 75192-1 or darthvader-1' }, allow_blank: true
          options.validates :page_size, :page_number, numericality: { only_integer: true }
          options.validates :order_by, inclusion: { in: Order::Types::ALL }
          options.validates :order_direction, inclusion: { in: Order::Direction::ALL }
        end

        validates :set_id, numericality: { only_integer: true }, on: [:set, :additional_images, :reviews, :instructions]
        validates :minutes_ago, numericality: { only_integer: true }, on: :recently_updated_sets
      end

      def sets(query: '', theme: '', subtheme: '', set_number: '', year: '', owned: '', wanted: '', order_by: 'number', page_size: 20, page_number: 1, username: '', order_direction: Order::Direction::ASC)
        self.set_number = set_number
        self.page_size = page_size
        self.page_number = page_number
        self.order_by = order_by
        self.order_direction = order_direction

        if valid?(:sets)
          # NOTE: all of the parameters are required, even though the API specifies them as optional.
          xml = call('/getSets', query: query, theme: theme, subtheme: subtheme, setNumber: set_number, year: year, owned: owned, wanted: wanted, orderBy: order, pageSize: page_size, pageNumber: page_number, userName: username)
          Brickset::Elements::Set.parse(xml)
        else
          raise ValidationError, self.errors.full_messages.to_sentence
        end
      end

      def set(set_id)
        self.set_id = set_id

        if valid?(:set)
          xml = call('/getSet', setID: set_id)
          Brickset::Elements::Set.parse(xml, single: true)
        else
          raise ValidationError, self.errors.full_messages.to_sentence
        end
      end

      def recently_updated_sets(minutes_ago)
        self.minutes_ago = minutes_ago

        if valid?(:recently_updated_sets)
          xml = call('/getRecentlyUpdatedSets', minutesAgo: minutes_ago)
          Brickset::Elements::Set.parse(xml)
        else
          raise ValidationError, self.errors.full_messages.to_sentence
        end
      end

      def additional_images(set_id)
        self.set_id = set_id

        if valid?(:additional_images)
          xml = call('/getAdditionalImages', setID: set_id)
          Brickset::Elements::AdditionalImage.parse(xml)
        else
          raise ValidationError, self.errors.full_messages.to_sentence
        end
      end

      def reviews(set_id)
        self.set_id = set_id

        if valid?(:reviews)
          xml = call('/getReviews', setID: set_id)
          Brickset::Elements::Review.parse(xml)
        else
          raise ValidationError, self.errors.full_messages.to_sentence
        end
      end

      def instructions(set_id)
        self.set_id = set_id

        if valid?(:instructions)
          xml = call('/getInstructions', setID: set_id)
          Brickset::Elements::Instruction.parse(xml)
        else
          raise ValidationError, self.errors.full_messages.to_sentence
        end
      end

      def themes
        xml = call('/getThemes')
        Brickset::Elements::Theme.parse(xml)
      end

      def subthemes(theme)
        xml = call('/getSubthemes', theme: theme)
        Brickset::Elements::Subtheme.parse(xml)
      end

      def years(theme)
        xml = call('/getYears', theme: theme)
        Brickset::Elements::Year.parse(xml)
      end

      def themes_for_user(owned: '', wanted: '')
        xml = call('/getThemesForUser', owned: owned, wanted: wanted)
        Brickset::Elements::Theme.parse(xml)
      end

      def subthemes_for_user(theme, owned: '', wanted: '')
        xml = call('/getSubthemesForUser', theme: theme, owned: owned, wanted: wanted)
        Brickset::Elements::Subtheme.parse(xml)
      end

      def years_for_user(theme, owned: '', wanted: '')
        xml = call('/getYearsForUser', theme: theme, owned: owned, wanted: wanted)
        Brickset::Elements::Year.parse(xml)
      end

      private

      def order
        if order_direction == Order::Direction::DESC
          [ order_by, order_direction.upcase ].join
        else
          order_by
        end
      end
    end
  end
end
