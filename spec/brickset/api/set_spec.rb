require 'spec_helper'

RSpec.describe Brickset::Client, type: :model do
  let(:api_key) { Brickset.configuration.api_key }
  let(:token)   { 'valid' }

  subject { described_class.new(token: token) }

  describe 'constants' do
    it { expect(described_class::Order::Types::NUMBER).to eq 'number' }
    it { expect(described_class::Order::Types::NAME).to eq 'name' }
    it { expect(described_class::Order::Types::THEME).to eq 'theme' }
    it { expect(described_class::Order::Types::PIECES).to eq 'pieces' }
    it { expect(described_class::Order::Types::RATING).to eq 'rating' }
    it { expect(described_class::Order::Types::SUBTHEME).to eq 'subtheme' }
    it { expect(described_class::Order::Types::MINIFIGS).to eq 'minifigs' }
    it { expect(described_class::Order::Types::YEAR_FROM).to eq 'yearfrom' }
    it { expect(described_class::Order::Types::RETAIL_PRICE_UK).to eq 'ukretailprice' }
    it { expect(described_class::Order::Types::RETAIL_PRICE_US).to eq 'usretailprice' }
    it { expect(described_class::Order::Types::RETAIL_PRICE_CA).to eq 'caretailprice' }
    it { expect(described_class::Order::Types::RETAIL_PRICE_EU).to eq 'euretailprice' }
    it { expect(described_class::Order::Types::RANDOM).to eq 'random' }
    it { expect(described_class::Order::Types::ALL).to match_array %w(number name theme pieces rating subtheme minifigs yearfrom ukretailprice usretailprice caretailprice euretailprice random) }

    it { expect(described_class::Order::Direction::ASC).to eq 'asc' }
    it { expect(described_class::Order::Direction::DESC).to eq 'desc' }
    it { expect(described_class::Order::Direction::ALL).to match_array %w(asc desc) }
  end

  describe 'validations' do
    it { is_expected.to allow_values('75192-1', 'darthvader-1').for(:set_number).on(:sets) }
    it { is_expected.to validate_numericality_of(:page_size).only_integer.on(:sets) }
    it { is_expected.to validate_numericality_of(:page_number).only_integer.on(:sets) }
    it { is_expected.to validate_inclusion_of(:order_by).in_array(described_class::Order::Types::ALL).on :sets }
    it { is_expected.to validate_inclusion_of(:order_direction).in_array(described_class::Order::Direction::ALL).on :sets }

    it { is_expected.to validate_numericality_of(:set_id).only_integer.on(:set) }
    it { is_expected.to validate_numericality_of(:set_id).only_integer.on(:additional_images) }
    it { is_expected.to validate_numericality_of(:set_id).only_integer.on(:reviews) }
    it { is_expected.to validate_numericality_of(:set_id).only_integer.on(:instructions) }

    it { is_expected.to validate_numericality_of(:minutes_ago).only_integer.on(:recently_updated_sets) }
  end

  describe '#sets' do
    let(:query) { '' }
    let(:theme) { '' }
    let(:subtheme) { '' }
    let(:set_number) { '' }
    let(:year) { '' }
    let(:owned) { '' }
    let(:wanted) { '' }
    let(:order_by) { 'number' }
    let(:page_size) { 20 }
    let(:page_number) { 1 }
    let(:username) { '' }

    let(:sets) { subject.sets(query: query, theme: theme, subtheme: subtheme, set_number: set_number, year: year, owned: owned, wanted: wanted, order_by: order_by, page_size: page_size, page_number: page_number, username: username) }

    context 'when all of the parameters are valid' do
      before { stub_post('/getSets').with(body: "query=#{query}&theme=#{theme}&subtheme=#{subtheme}&setNumber=#{set_number}&year=#{year}&owned=#{owned}&wanted=#{wanted}&orderBy=#{order_by}&pageSize=#{page_size}&pageNumber=#{page_number}&userName=#{username}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when there is a result' do
        let(:body) { fixture('get_sets.xml') }

        it 'returns the sets' do
          expect(sets).to match_array [
            an_instance_of(Brickset::Elements::Set),
            an_instance_of(Brickset::Elements::Set)
          ]
        end
      end

      context 'when there is no result' do
        let(:body) { fixture('get_sets_no_result.xml') }

        it 'returns an empty array' do
          expect(sets).to match_array []
        end
      end
    end

    context 'when not all of the parameters are valid' do
      let(:set_number) { '12345-a' }
      let(:order_by) { 'non-existent' }

      it 'raises a ValidationError' do
        expect { sets }.to raise_error Brickset::ValidationError, 'Set number format of <number>-<variant>, e.g. 75192-1 or darthvader-1 and Order by is not included in the list'
      end
    end
  end

  describe '#set' do
    let(:set_id) { 5860 }
    let(:set) { subject.set(set_id) }

    context 'when the set ID is an integer' do
      before { stub_post('/getSet').with(body: "setID=#{set_id}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when there is a result' do
        let(:body) { fixture('get_set.xml') }

        it 'returns the set' do
          expect(set).to an_instance_of(Brickset::Elements::Set)
        end
      end

      context 'when there is no result' do
        let(:body) { fixture('get_set_no_result.xml') }

        it 'returns nil' do
          expect(set).to be_nil
        end
      end
    end

    context 'when the set ID is not an integer' do
      let(:set_id) { 'set-number' }

      it 'raises a ValidationError' do
        expect { set }.to raise_error Brickset::ValidationError, 'Set is not a number'
      end
    end
  end

  describe '#recently_updated_sets' do
    let(:minutes_ago) { 60 }

    let(:recently_updated_sets) { subject.recently_updated_sets(minutes_ago) }

    context 'when minutes ago is an integer' do
      context 'with a valid API key' do
        before { stub_post('/getRecentlyUpdatedSets').with(body: "minutesAgo=#{minutes_ago}&apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('get_recently_updated_sets.xml') }

        it 'receives the recently updated sets' do
          expect(recently_updated_sets).to match_array [ an_instance_of(Brickset::Elements::Set) ]
        end
      end

      context 'with an invalid API key' do
        let(:api_key) { 'invalid' }

        before do
          allow(Brickset).to receive(:configuration).and_return double(api_key: api_key)
          stub_post('/getRecentlyUpdatedSets').with(body: "minutesAgo=#{minutes_ago}&apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('get_recently_updated_sets_invalid_key.xml')
        end

        it 'does not receive any recently updated sets' do
          expect(recently_updated_sets).to match_array []
        end
      end
    end

    context 'when minutes ago is not an integer' do
      let(:minutes_ago) { 'five' }

      it 'raises a ValidationError' do
        expect { recently_updated_sets }.to raise_error Brickset::ValidationError, 'Minutes ago is not a number'
      end
    end
  end

  describe '#additional_images' do
    let(:set_id) { 5860 }
    let(:additional_images) { subject.additional_images(set_id) }

    context 'when the set ID is an integer' do
      before { stub_post('/getAdditionalImages').with(body: "setID=#{set_id}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when there is a result' do
        let(:body) { fixture('get_additional_images.xml') }

        it 'returns the instructions' do
          expect(additional_images).to match_array [
            an_instance_of(Brickset::Elements::AdditionalImage),
            an_instance_of(Brickset::Elements::AdditionalImage),
            an_instance_of(Brickset::Elements::AdditionalImage),
            an_instance_of(Brickset::Elements::AdditionalImage),
            an_instance_of(Brickset::Elements::AdditionalImage)
          ]
        end
      end

      context 'when there is no result' do
        let(:body) { fixture('get_additional_images_no_result.xml') }

        it 'returns an empty array' do
          expect(additional_images).to match_array []
        end
      end
    end

    context 'when the set ID is not an integer' do
      let(:set_id) { 'set-number' }

      it 'raises a ValidationError' do
        expect { additional_images }.to raise_error Brickset::ValidationError, 'Set is not a number'
      end
    end
  end

  describe '#reviews' do
    let(:set_id) { 5860 }
    let(:reviews) { subject.reviews(set_id) }

    context 'when the set ID is an integer' do
      before { stub_post('/getReviews').with(body: "setID=#{set_id}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when there is a result' do
        let(:body) { fixture('get_reviews.xml') }

        it 'returns the instructions' do
          expect(reviews).to match_array [ an_instance_of(Brickset::Elements::Review) ]
        end
      end

      context 'when there is no result' do
        let(:body) { fixture('get_reviews_no_result.xml') }

        it 'returns an empty array' do
          expect(reviews).to match_array []
        end
      end
    end

    context 'when the set ID is not an integer' do
      let(:set_id) { 'set-number' }

      it 'raises a ValidationError' do
        expect { reviews }.to raise_error Brickset::ValidationError, 'Set is not a number'
      end
    end
  end

  describe '#instructions' do
    let(:set_id) { 5860 }
    let(:instructions) { subject.instructions(set_id) }

    context 'when the set ID is an integer' do
      before { stub_post('/getInstructions').with(body: "setID=#{set_id}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when there is a result' do
        let(:body) { fixture('get_instructions.xml') }

        it 'returns the instructions' do
          expect(instructions).to match_array [ an_instance_of(Brickset::Elements::Instruction) ]
        end
      end

      context 'when there is no result' do
        let(:body) { fixture('get_instructions_no_result.xml') }

        it 'returns an empty array' do
          expect(instructions).to match_array []
        end
      end
    end

    context 'when the set ID is not an integer' do
      let(:set_id) { 'set-number' }

      it 'raises a ValidationError' do
        expect { instructions }.to raise_error Brickset::ValidationError, 'Set is not a number'
      end
    end
  end

  describe '#themes' do
    let(:themes) { subject.themes }

    before { stub_post('/getThemes').with(body: "apiKey=#{api_key}&userHash=#{token}").to_return body: body }

    context 'when there is a result' do
      let(:body) { fixture('get_themes.xml') }

      it 'returns the themes' do
        expect(themes).to match_array [
          an_instance_of(Brickset::Elements::Theme),
          an_instance_of(Brickset::Elements::Theme)
        ]
      end

      it 'knows the number of sets and subthemes of the a theme' do
        aggregate_failures do
          expect(themes.last.theme).to eq 'Star Wars'
          expect(themes.last.set_count).to eq 821
          expect(themes.last.subtheme_count).to eq 29
        end
      end
    end

    context 'when there is no result' do
      let(:body) { fixture('get_themes_no_result.xml') }

      it 'returns an empty array' do
        expect(themes).to match_array []
      end
    end
  end

  describe '#subthemes' do
    let(:theme) { 'Star Wars' }
    let(:subthemes) { subject.subthemes(theme) }

    before { stub_post('/getSubthemes').with(body: "theme=#{ERB::Util.url_encode(theme)}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

    context 'when there is a result' do
      let(:body) { fixture('get_subthemes.xml') }

      it 'returns the subthemes for the specified theme' do
        expect(subthemes).to match_array [
          an_instance_of(Brickset::Elements::Subtheme),
          an_instance_of(Brickset::Elements::Subtheme),
          an_instance_of(Brickset::Elements::Subtheme)
        ]
      end

      it 'knows the number of sets of the subtheme for the specified theme' do
        aggregate_failures do
          expect(subthemes.last.subtheme).to eq 'MicroFighters'
          expect(subthemes.last.set_count).to eq 26
        end
      end
    end

    context 'when there is no result' do
      let(:theme) { 'Star Warz' }

      let(:body) { fixture('get_subthemes_no_result.xml') }

      it 'returns an empty array' do
        expect(subthemes).to match_array []
      end
    end
  end

  describe '#years' do
    let(:theme) { 'Star Wars' }
    let(:years) { subject.years(theme) }

    before { stub_post('/getYears').with(body: "theme=#{ERB::Util.url_encode(theme)}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

    context 'when there is a result' do
      let(:body) { fixture('get_years.xml') }

      it 'returns the years for the specified theme' do
        expect(years).to match_array [
          an_instance_of(Brickset::Elements::Year),
          an_instance_of(Brickset::Elements::Year),
          an_instance_of(Brickset::Elements::Year)
        ]
      end

      it 'knows the number of sets of the years for the specified theme' do
        aggregate_failures do
          expect(years.last.year).to eq '2018'
          expect(years.last.set_count).to eq 64
        end
      end
    end

    context 'when there is no result' do
      let(:theme) { 'Star Warz' }

      let(:body) { fixture('get_years_no_result.xml') }

      it 'returns an empty array' do
        expect(years).to match_array []
      end
    end
  end

  describe '#themes_for_user' do
    let(:owned) { nil }
    let(:wanted) { nil }

    let(:themes_for_user) { subject.themes_for_user(owned: owned, wanted: wanted) }

    before { stub_post('/getThemesForUser').with(body: "owned=#{owned}&wanted=#{wanted}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

    context 'when there is a result' do
      context 'when no parameter is specified' do
        let(:body) { fixture('get_themes_for_user.xml') }

        it 'returns the themes for the user' do
          expect(themes_for_user).to match_array [
            an_instance_of(Brickset::Elements::Theme),
            an_instance_of(Brickset::Elements::Theme)
          ]
        end

        it 'knows the subtheme count, year from and to of the themes for the user' do
          aggregate_failures do
            expect(themes_for_user.last.subtheme_count).to eq 29
            expect(themes_for_user.last.year_from).to eq 1999
            expect(themes_for_user.last.year_to).to eq 2018
          end
        end

        it 'knows the number of sets of the themes for the user' do
          expect(themes_for_user.last.set_count).to eq 821
        end
      end

      context 'when an owned theme is specified' do
        let(:body) { fixture('get_themes_for_user_owned.xml') }

        it 'returns the owned themes for the user' do
          expect(themes_for_user).to match_array [
            an_instance_of(Brickset::Elements::Theme),
            an_instance_of(Brickset::Elements::Theme)
          ]
        end

        it 'knows that the subtheme count, year from and to of the owned themes for the user are not populated' do
          aggregate_failures do
            expect(themes_for_user.last.subtheme_count).to eq 0
            expect(themes_for_user.last.year_from).to eq 0
            expect(themes_for_user.last.year_to).to eq 0
          end
        end

        it 'knows the number of sets of the owned themes for the user' do
          expect(themes_for_user.last.set_count).to eq 26
        end
      end

      context 'when a wanted theme is specified' do
        let(:body) { fixture('get_themes_for_user_wanted.xml') }

        it 'returns the wanted themes for the user' do
          expect(themes_for_user).to match_array [
            an_instance_of(Brickset::Elements::Theme),
            an_instance_of(Brickset::Elements::Theme),
            an_instance_of(Brickset::Elements::Theme)
          ]
        end

        it 'knows that the subtheme count, year from and to of the wanted themes for the user are not populated' do
          aggregate_failures do
            expect(themes_for_user.last.subtheme_count).to eq 0
            expect(themes_for_user.last.year_from).to eq 0
            expect(themes_for_user.last.year_to).to eq 0
          end
        end

        it 'knows the number of sets of the wanted themes for the user' do
          expect(themes_for_user.last.set_count).to eq 3
        end
      end
    end

    context 'when there is no result' do
      let(:body) { fixture('get_themes_for_user_no_result.xml') }

      it 'returns an empty array' do
        expect(themes_for_user).to match_array []
      end
    end
  end

  describe '#subthemes_for_user' do
    let(:theme) { 'Star Wars' }
    let(:owned) { nil }
    let(:wanted) { nil }

    let(:subthemes_for_user) { subject.subthemes_for_user(theme, owned: owned, wanted: wanted) }

    before { stub_post('/getSubthemesForUser').with(body: "theme=#{ERB::Util.url_encode(theme)}&owned=#{owned}&wanted=#{wanted}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

    context 'when there is a result' do
      context 'when only a theme is specified' do
        let(:body) { fixture('get_subthemes_for_user.xml') }

        it 'returns the subthemes for the specified theme' do
          expect(subthemes_for_user).to match_array [
            an_instance_of(Brickset::Elements::Subtheme),
            an_instance_of(Brickset::Elements::Subtheme),
            an_instance_of(Brickset::Elements::Subtheme)
          ]
        end

        it 'knows the year from and to of the subthemes for the specified theme' do
          aggregate_failures do
            expect(subthemes_for_user.last.year_from).to eq 2014
            expect(subthemes_for_user.last.year_to).to eq 2018
          end
        end

        it 'knows the number of sets of the subthemes for the specified theme' do
          expect(subthemes_for_user.last.set_count).to eq 26
        end
      end

      context 'when an owned theme is specified' do
        let(:body) { fixture('get_subthemes_for_user_owned.xml') }

        it 'returns the subthemes for the specified owned theme' do
          expect(subthemes_for_user).to match_array [
            an_instance_of(Brickset::Elements::Subtheme),
            an_instance_of(Brickset::Elements::Subtheme),
            an_instance_of(Brickset::Elements::Subtheme)
          ]
        end

        it 'knows that the year from and to of the subthemes for the specified owned theme are not populated' do
          aggregate_failures do
            expect(subthemes_for_user.last.year_from).to eq 0
            expect(subthemes_for_user.last.year_to).to eq 0
          end
        end

        it 'knows the number of sets of the subthemes for the specified owned theme' do
          expect(subthemes_for_user.last.set_count).to eq 2
        end
      end

      context 'when a wanted theme is specified' do
        let(:body) { fixture('get_subthemes_for_user_wanted.xml') }

        it 'returns the subthemes for the specified wanted theme' do
          expect(subthemes_for_user).to match_array [
            an_instance_of(Brickset::Elements::Subtheme),
            an_instance_of(Brickset::Elements::Subtheme),
            an_instance_of(Brickset::Elements::Subtheme),
            an_instance_of(Brickset::Elements::Subtheme)
          ]
        end

        it 'knows that the year from and to of the subthemes for the specified wanted theme are not populated' do
          aggregate_failures do
            expect(subthemes_for_user.last.year_from).to eq 0
            expect(subthemes_for_user.last.year_to).to eq 0
          end
        end

        it 'knows the number of sets of the subthemes for the specified wanted theme' do
          expect(subthemes_for_user.last.set_count).to eq 1
        end
      end
    end

    context 'when there is no result' do
      let(:theme) { 'Star Warz' }

      let(:body) { fixture('get_subthemes_for_user_no_result.xml') }

      it 'returns an empty array' do
        expect(subthemes_for_user).to match_array []
      end
    end
  end

  describe '#years_for_user' do
    let(:theme) { 'Star Wars' }
    let(:owned) { nil }
    let(:wanted) { nil }

    let(:years_for_user) { subject.years_for_user(theme, owned: owned, wanted: wanted) }

    before { stub_post('/getYearsForUser').with(body: "theme=#{ERB::Util.url_encode(theme)}&owned=#{owned}&wanted=#{wanted}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

    context 'when there is a result' do
      context 'when only a theme is specified' do
        let(:body) { fixture('get_years_for_user.xml') }

        it 'returns the years for the specified theme' do
          expect(years_for_user).to match_array [
            an_instance_of(Brickset::Elements::Year),
            an_instance_of(Brickset::Elements::Year),
            an_instance_of(Brickset::Elements::Year)
          ]
        end

        it 'knows the number of sets of the years for the specified theme' do
          aggregate_failures do
            expect(years_for_user.last.year).to eq '2018'
            expect(years_for_user.last.set_count).to eq 64
          end
        end
      end

      context 'when an owned theme is specified' do
        let(:body) { fixture('get_years_for_user_owned.xml') }

        it 'returns the years for the specified owned theme' do
          expect(years_for_user).to match_array [
            an_instance_of(Brickset::Elements::Year),
            an_instance_of(Brickset::Elements::Year)
          ]
        end

        it 'knows the number of sets of the years for the specified owned theme' do
          aggregate_failures do
            expect(years_for_user.last.year).to eq '2018'
            expect(years_for_user.last.set_count).to eq 3
          end
        end
      end

      context 'when a wanted theme is specified' do
        let(:body) { fixture('get_years_for_user_wanted.xml') }

        it 'returns the years for the specified wanted theme' do
          expect(years_for_user).to match_array [
            an_instance_of(Brickset::Elements::Year),
            an_instance_of(Brickset::Elements::Year)
          ]
        end

        it 'knows the number of sets of the years for the specified wanted theme' do
          aggregate_failures do
            expect(years_for_user.last.year).to eq '2018'
            expect(years_for_user.last.set_count).to eq 50
          end
        end
      end
    end

    context 'when there is no result' do
      let(:theme) { 'Star Warz' }

      let(:body) { fixture('get_years_for_user_no_result.xml') }

      it 'returns an empty array' do
        expect(years_for_user).to match_array []
      end
    end
  end

  describe '#order' do
    let(:order) { subject.send(:order) }

    let(:order_by) { 'number' }

    before do
      subject.order_by = order_by
      subject.order_direction = order_direction
    end

    context 'when the order direction is desc' do
      let(:order_direction) { described_class::Order::Direction::DESC }

      it 'concatenates the order by and order direction' do
        expect(order).to eq 'numberDESC'
      end
    end

    context 'when the order is not desc' do
      let(:order_direction) { described_class::Order::Direction::ASC }

      it 'returns the order_by' do
        expect(order).to eq 'number'
      end
    end
  end

end
