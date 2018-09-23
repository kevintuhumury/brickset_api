# Brickset

This gem provides a Ruby wrapper around the [Brickset](https://brickset.com) (v2) API, using HTTParty. Brickset is a library to access the Brickset API in an easy way. It wraps all of the methods, which are described in the [official documentation](https://brickset.com/tools/webservices/v2). The Brickset API by default responds with XML. This gem maps the XML responses to Ruby objects using HappyMapper.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'brickset_api', require: 'brickset'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brickset_api

### Apply for an API key

You can retrieve an API key from the official Brickset [site](https://brickset.com/tools/webservices/requestkey). Just follow the instructions and once you've received the API key move on to the next step.

### Configuration

In order for you to use the Brickset gem, you'll need to configure the API key you've requested in the previous step. If you're using Rails, you could add the following to e.g. `config/initializers/brickset.rb`:

```ruby
Brickset.configure do |config|
  config.api_key = '<API_KEY>'
end
```

That's it. You're now ready to start using this gem.

## Usage

Using Brickset is easy. All you need to know is that all calls go through the `Brickset::Client` class. Most of the API calls provided by the Brickset v2 API require you to sign into Brickset in order for you to retrieve a token (which they call a `userHash`). This `token` can than be used to call the authenticated API calls and retrieve information of the signed in user.

Now, you're not required to do so, but if you don't, you will only be able to retrieve generic information from the API. User specific information will not be accessible.

### Create an instance of the Brickset client

In order to retrieve data from the API, we'll need an instance of the Brickset client. So let's create it:

```ruby
client = Brickset.client
```

Yeah, that's it.

### Create an instance of the Brickset client with access to authenticated API calls

If you want to retrieve user specific information you'll need a token. You can retrieve one as follows:

```ruby
token = Brickset.login('<YOUR_USERNAME>', '<YOUR_PASSWORD>')
```

Now that you have access to the token, provide the client with it and you'll be good to go:

```ruby
client = Brickset.client(token: token)
```

That's it.

### Helper methods

There are two helper methods that you can use to check whether your API key and token are valid. Both of them will return a Boolean value. You can use them as follows:

```ruby
client.valid_api_key? # => true
client.valid_token?   # => true
```

### Calling API methods

Now, let's call our `sets` method with `Star Wars` (because its awesome, obviously) as a theme:

```ruby
sets = client.sets(theme: 'Star Wars')
```

The above call will return all sets that are in the `Star Wars` theme. As can be seen on the [API page](https://brickset.com/tools/webservices/v2) (look for `getSets`), there's a default limit of 20 records per page to retrieve. You could change that with the following:

```ruby
sets = client.sets(theme: 'Star Wars', page_size: 50)
```

Or navigate to the second page:

```ruby
sets = client.sets(theme: 'Star Wars', page_number: 2)
```

Let's say you're looking for the `Ultimate Collector Series` sets and more specifically the ones based on the `Millenium Falcon`. You can retrieve those with the following example:

```ruby
sets = client.sets(theme: 'Star Wars', subtheme: 'Ultimate Collector Series', query: 'Millenium Falcon')
```

At the time of writing this will result in two sets: `10179-1` from 2007 and `75192-1` from 2017. Let's say we want to select the last one to view its data:

```ruby
sets = client.sets(theme: 'Star Wars', subtheme: 'Ultimate Collector Series', query: 'Millenium Falcon')
set  = sets.last           # => #<Brickset::Elements::Set:0x000055ad9ddfdd60 @set_id=26725, @number="75192", @number_variant=1, @name="Millennium Falcon", @year="2017", @description=nil, @category="Normal", @theme="Star Wars", @theme_group="Licensed", @subtheme="Ultimate Collector Series", @pieces="7541", @minifigs="8", @image=true, @image_url="https://images.brickset.com/sets/images/75192-1.jpg", @image_filename="75192-1", @thumbnail_url="https://images.brickset.com/sets/thumbs/tn_75192-1_jpg.jpg", @thumbnail_url_large="https://images.brickset.com/sets/small/75192-1.jpg", @brickset_url="https://brickset.com/sets/75192-1", @owned_by_total=5194, @wanted_by_total=4551, @released=true, @rating=5.0, @user_rating=4, @review_count=3, @instructions_count=2, @additional_image_count=61, @last_updated=Thu, 14 Sep 2017, @age_minimum=16, @age_maximum=nil, @notes=nil, @tags=nil, @retail_price_uk="649.99", @retail_price_us="799.99", @retail_price_ca="899.99", @retail_price_eu="799.99", @date_added_to_shop="2018-01-10", @date_removed_from_shop="", @packaging_type="Box", @height=0.0, @width=0.0, @depth=0.0, @weight=0.0, @availability="LEGO exclusive", @ean="", @upc="", @acm_data_count=0, @owned=true, @wanted=true, @number_owned=1, @user_notes="">

set.id                     # => 26725
set.pieces                 # => '7541'
set.image_url              # => 'https://images.brickset.com/sets/images/75192-1.jpg'
set.additional_image_count # => 61
```

You could now use `additional_images` to retrieve the 61 additional images from the above set. Simply supply the API call with the set ID:

```ruby
client.additional_images(set.id)

# => [#<Brickset::Elements::AdditionalImage:0x000055ad9e0292b0 @thumbnail_url="https://images.brickset.com/sets/AdditionalImages/75192-1/tn_75192_1to1_jpg.jpg", @thumbnail_url_large=nil, @image_url="https://images.brickset.com/sets/AdditionalImages/75192-1/75192_1to1.jpg">, #<Brickset::Elements::AdditionalImage:0x000055ad9e027d98 @thumbnail_url="https://images.brickset.com/sets/AdditionalImages/75192-1/tn_75192_alt10_jpg.jpg", @thumbnail_url_large=nil, @image_url="https://images.brickset.com/sets/AdditionalImages/75192-1/75192_alt10.jpg">, ...]
```

It really is that easy. Need a specific method? Look for them in the `lib/brickset/api` directory.

## Contributing

You're very welcome to contribute to this gem. To do so, please follow these steps:

1. Fork this project
2. Clone your fork on your local machine
3. Install the development dependencies with `bin/setup`
4. Create your feature branch with `git checkout -b my-new-feature`
5. Run the specs with `bundle exec rspec` and make sure everything is covered with RSpec
6. Commit your changes `git commit -am 'Added new feature'`
7. Push to your branch `git push origin my-new-feature`
8. Create a new Pull Request

You can run `bin/console` for an interactive prompt that will allow you to experiment.

## Copyright

Copyright 2018 Kevin Tuhumury. Released under the MIT License.
