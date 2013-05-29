# RailsBigBrother

RailsBigBrother lets you log every create, update and destroy on any of your models.

## Installation

Add this line to your application's Gemfile:

    gem 'rails_big_brother'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_big_brother

## Usage

Simply add this line in the model you want to log :
```ruby
big_brother_watch
```

### Define log format

The default log format is :
```ruby
"%<big_brother>s;%<user>s;%<controller_info>s;%<class>s;%<id>s;%<action>s;%<args>s"
```

To define a new format, add this in an initializer :
```ruby
RailsBigBrother.format = "new_format"
```

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
