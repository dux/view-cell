<img src="https://i.imgur.com/nQ7iNPy.png" align="right" title="image stolen from some js/react plugin"/>

# view-cell / ruby

View cell is clean, simple explicit and strait-forward web view cell/component for use in Rails/Sinatra/Lux.

A cell is an object that represent a fragment of your UI. It can embrace an entire page, a single comment container in a thread or just an avatar image link.

Simplifed, a cell is an object that can render a template or return html data from html builder as `html-tag`.

## Installation

to install

`gem install view-cell`

or in Gemfile

`gem 'view-cell'`

and to use

`require 'view-cell'`

## How to use

Common usage is to use it views, but they you can easily use it standalone.

## Usage

### Simple example

Basic example

```ruby
require 'view-cell'

# foo_cell.rb
class FooCell < ViewCell
  def bar
    :baz
  end

  def sq num
    num * num
  end
end

FooCell.new.bar # :baz

# index.html.erb
<%= cell.foo.bar %>   # :baz
<%= cell.foo.sq(3) %> # 9
```

### Example for template render

If yo want to keep template in separate file

```ruby
# foo_cell.rb
class FooCell < ViewCell
  # defaults to current cell folder, but can be set to any path
  template_root './app/views/cells'

  # delegate image_tag method call to parent (caller scope)
  # in Rails that would be ActionView::Base
  delegate :image_tag

  def bar num
    @number = num
    template :bar
  end
end

# bar.html.haml
= image_tag '/foo.png'            # when delegated to parent
= parent.image_tag '/foo.png'     # if you do not want to delegate :image_tag
= parent { image_tag '/foo.png' } # same
= @number * @number               # instance varibles are passed

```

### Return html with integrated tag builder (using <a href="https://github.com/dux/html-tag">html-tag</a> gem)

It is usually easier to build html then use templates

```ruby
# ./app/lib/cell/foo_cell.rb
require 'html-tag'

class FooCell < ViewCell
  def bar
    tag.div class: :bar do
      p 'foo'
    end
  end
end

# ./app/views/index.erb
<%= cell.foo.bar %> # <div class="bar"><p>foo</p></div>
```

### Integrated css / scss parser

Uses `gem 'scssc'` (`https://github.com/sass/sassc-ruby`, loaded only if used) to add integrated css capabilities

```ruby
# ./app/lib/cell/foo_cell.rb
class FooCell < ViewCell
  # css / scss file path
  css 'foo/bar.scss'

  # add inline css / scss
  css %[
    .foo {
      .bar {
        font-weight: bold;
      }
    }
  ]
end

ViewCell.css # get compiled css
```

### Annotated example with all features explained

* `before` in `ApplicationCell` superclass and `before` in `FooCell` will be called before any code
* `delegate` will send any message from cell to a parent. you need to use that if you want to use Rails view methods like `image_tag` without `parent` prefix.
* template -> renders template
  * `template_root` will point to root folder for templates defined as symbol. You can use `%s` to be replaced by template part (`FooCell` -> `foo`).
  * `template :symbol` -> render using default path or using `template_root`
  * `template 'relative/path'` -> render using default path or using `template_root`
  * `template '/abslute/path'` -> does not use `template_root`

```ruby
class ApplicationCell < ViewCell
  # delegate calls to parent (caller scope)
  # this will work if cell is called from a view, not if it is called from a controller
  delegate :request, :session, :current_user, :image_tag

  # css / scss file path
  css 'foo/bar.scss'

  # add inline css / scss
  css %[
    .foo {
      .bar {
        font-weight: bold;
      }
    }
  ]

  # define before in superclass
  def before
    # define @user as method call from parent
    @user = parent { user }

    # same thing
    @user = parent.user

    # you can copy instance variables from parent scope
    @foo = parent { @foo }

    # same thing
    @foo = parent.instance_varaible_get :@foo
  end
end

class FooCell < ApplicationCell
  # define before in current class
  # it will be called before any method call
  def before
    super
    @time = Time.now
  end

  # same thing
  before do
    @time = Time.now
  end

  # defaults to './app/views/' + class_part
  # but can be set to any path
  # %s is reference for class_part
  template_root './app/views/cells/%s'

  def bar num
    # define instance variable available in templates
    @number = num

    # renders './app/views/cells/foo/bar.[erb, haml]'
    template :bar

    # renders './app/views/cells/custom/bar.[erb, haml]'
    template 'custom/bar'

    # renders './custom/bar.[erb, haml]'
    template './custom/bar'
  end
end
```

### cell view - syntax sugar

You can pass object or list of objects to `cell` view method.

```ruby
# cell.user.render(user)
= cell @user

# @users.each { |user| cell.user.render(user) }.join('')
= cell @users
```

### Raw usage for controlers and console

```ruby
class FooCell < ViewCell
  def sq num=nil
    num ||= @number
    num * num
  end
end

cell = FooCell.new(self || or_any_scope_you_wish)
cell.sq(3) # 8

# hash keys passed as params are converted to instance varialbes
# in this case @number = 4
cell = FooCell.new(self, number: 4)
cell.sq # 16

# or dinamic alternative
ViewCell.get(self, :foo, number: 5).sq # 25
```

### Manual install of cell proxy method

This will enable usage of `cell.name.method` proxy helper.

```ruby
class CustomClass
  include ViewCell::ProxyMethod
end
```

## Test

`rake test`

## Dependency

* `tilt` gem &sdot; [link](https://github.com/rtomayko/tilt) &sdot; allready included with by Rails
* `dry-inflector` gem &sdot; [link](https://github.com/dry-rb/dry-inflector) &sdot; only if not using Rails

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dux/view-cell.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
