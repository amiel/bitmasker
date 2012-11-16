HasBitmaskAttributes
====================

Bitmask Attributes allows you to store many boolean values as one integer field in the database.

Synopsis
--------


```ruby
  class User < ActiveRecord::Base
    has_bitmask_attributes :notifications do |config|
      config.attribute :send_weekly_newsletter,    0b0001
      config.attribute :send_monthly_newsletter,   0b0010, true
    end
  end
```

Examples
--------

```ruby
  # in migration
  t.integer :notifications_mask

  # in app/models/user.rb
  class User < ActiveRecord::Base
    has_bitmask_attributes :notifications do |config|
      config.attribute :send_weekly_newsletter,    0b0001
      config.attribute :send_monthly_newsletter,   0b0010, true
      config.accessible
      # config.field_name :notifications_mask # <- default functionality
    end
  end
```

this will define the following methods:
* `User#notifications` -- returns a BitmaskAttributes object representing all values
* `User#send_weekly_newsletter?` -- predicate
* `User#send_weekly_newsletter` -- works just like the predicate, makes it easy to use actionview form helpers
* `User#send_weekly_newsletter=(value)` -- just give it a boolean value (also takes "0" and "1" or "t" and "f" just like activerecord does for boolean fields)
* `User#send_monthly_newsletter?`
* `User#send_monthly_newsletter`
* `User#send_monthly_newsletter=(value)`

the call to `config.accessible` calls `attr_accessible :send_weekly_newsletter, :send_monthly_newsletter` in your model



View Example
------------

```erb
  # in your view
  <% form_for @user do |f| %>
    Monthly Newsletter: <%= f.check_box :send_monthly_newsletter? %>
    or
    Monthly Newsletter
    Yes: <%= f.radio_button :send_monthly_newsletter, 'true' %>
    No: <%= f.radio_button :send_monthly_newsletter, 'false' %>
  <% end %>
```


Config Options
--------------

`config.attribute(name, mask, default = false)`

Sets up a binary attribute. Defines three functions: name, name?, and name=(true|false)
* `name`    a symbol, HasBitmaskAttributes will define
* `mask`    example: 0b0000001, must be a power of 2
* `default`   set to true if you want the attribute to default to true

`config.accessible`
if you are using attr_accessible in your model and you want to mass-assign your bitmask attributes, you will want to call this

`config.field_name(name)`
* `name`    name of the field name in the database where all this info is stored, should be an integer


Copyright (c) 2012 Amiel Martin, released under the MIT license

