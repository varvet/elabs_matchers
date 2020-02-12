# Elabs matchers

[![Build Status](https://secure.travis-ci.org/elabs/elabs_matchers.png)](http://travis-ci.org/elabs/elabs_matchers)

Elabs matchers aims to extend existing rspec matchers from e.g Rspec, Rspec-rails and Capybara with a set
of less generic once. This could be things like asserting a table appearing in a certain way or check that
an active record instance has been successfully persisted after an update.

It is important to know that this gem aims to extend rspec / capybara with more matchers. If functionality in either of theses
makes any of elabs matchers' matchers obsolete they will be deprecated and removed from elabs matchers.

Below follows a list of matchers that the gem bundles. To get documentation about each matcher the source code is
your best friend at this point.

## Setup

add elabs_matchers to your Gemfile:

```ruby
gem "elabs_matchers"
```

### Model matchers:
```ruby
record.should be_valid_with("Blog post").as(:title)
hash.contain_hash({ "baz" => "bar" })
array.only_include("bar", "foo")
record.should persist(:title, "Blog post")
```

### Model helpers:
```ruby
reload(post)
save_and_reload(post)
```

### Acceptance matchers:
```ruby
page.should have_flash_notice("Success")
page.should have_flash_alert("Error")
page.should have_form_errors_on("Name", "Can't be blank")
page.should have_header("Elabs")
page.should have_image("Logo")
page.should have_fields("Author" => "Adam", "Year" => "2011")
page.should have_table_row("Posts", "Title" => "First", :year => "2012") # Moved to https://github.com/jnicklas/capybara_table
page.should have_attribute("Status", "Pending")
```

### Acceptance helpers:
```ruby
select_year_and_month("2010", "March", :from => "Birth date")
```

### Common helpers:
```ruby
normalize_keys({ "First name" => "Adam" })
fixture_file("file.txt")
```

## Configuration

Matchers can be configured in e.g your spec_helper.rb-file:

```ruby
ElabsMatchers.configure do |config|
  config.header_selector = "//h1"
  config.header_selector_type = :xpath
  config.image_selector = lambda { |src| "img[src='#{src}']" }
end
```

See [elabs_matchers.rb](https://github.com/elabs/elabs_matchers/blob/master/lib/elabs_matchers.rb)


## More
The gem includes YARD documentation which can be read with any browser.
The gem's test suite should also serve as detailed documentation for each matcher and helper.


## Development

See [development.md](https://github.com/elabs/elabs_matchers/blob/master/development.md)

## Contributors

So far the code base is a joined effort by everyone at Elabs.

## License:

 (The MIT License)

 Copyright (c) 2012 Elabs AB

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
