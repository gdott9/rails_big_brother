# RailsBigBrother

RailsBigBrother lets you log every create, update and destroy on any of your models.

## Installation

Add this line to your application's Gemfile:

    gem 'rails_big_brother'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_big_brother

## Configuration

```ruby
RailsBigBrother.config do |config|
  config.format = "big_brother;%<user>s;%<controller_info>s;%<class>s;%<id>s;%<action>s;%<args>s"
  config.logger = Rails.logger
  config.hash_to_s = proc { |hash| hash.map { |k,v| "#{k}:#{v}" }.join(',') }
  config.array_to_s = proc { |array| array.join(',') }
end
```

## Usage

Simply add this line in the model you want to log :
```ruby
big_brother_watch
```

### User and controller info

To fill user and controller info, you need to define two methods in your `ApplicationController`
```ruby
def big_brother_user
  ''
end

def big_brother_infos
  {}
end
```
`big_brother_user` must return a string.
`big_brother_infos` can return a string, an array or a hash.

### Choose events to log

You can choose which events to log with the `on` option. For example :
```ruby
class Example < ActiveRecord::Base
  big_brother_watch on: [:create, :destroy]
end
```

### Select attributes to log

You can specify attributes to monitor with `only` :
```ruby
class Example < ActiveRecord::Base
  big_brother_watch only: [:first, :second]
end
```

You can also ignore some attributes with `ignore` :
```ruby
class Example < ActiveRecord::Base
  big_brother_watch ignore: :third
end
```

### Log attributes new value on update

You can choose to log the new value of an updated field with `verbose` :
```ruby
class Example < ActiveRecord::Base
  big_brother_watch verbose: :third
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
