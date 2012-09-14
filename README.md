# Elabs matchers

[![Build Status](https://secure.travis-ci.org/elabs/elabs_matchers.png)](http://travis-ci.org/elabs/elabs_matchers)

Elabs matchers aims to extend existing rspec matchers from e.g Rspec, Rspec-rails and Capybara with a set
of less generic once. This could be things like asserting a table appearing in a certain way or check that
an active record instance has been successfully persisted after an update.

Below follows a list of matchers that the gem bundles. To get documentation about each matcher the source code is
your bast friend at this point.

### Model matchers:
* record.should allow("Blog post").as(:title)
* hash.contain_hash({ "baz" => "bar" })
* array.only_include("bar", "foo")
* record.should persist(:title, "Blog post")

### Model helpers:
* reload(post)
* save\_and_reload(post)

### Acceptance matchers:
* page.should have\_flash_notice("Success")
* page.should have\_flash_alert("Error")
* page.should have\_form\_errors_on("Name", "Can't be blank")
* page.should have\_header("Elabs")
* page.should have\_image("Logo")
* page.should have\_fields("Author" => "Adam", "Year" => "2011")
* page.should have\_table_row("Posts", "Title" => "First", :year => "2012")
* page.should have\_attribute("Status", "Pending")

### Acceptance helpers:
* select\_year\_and_month("2010", "March", :from => "Birth date")

### Common helpers:
* select\_year\_and_month("2010", "March", :from => "Birth date")
* normalize_keys({ "First name" => "Adam" })
* fixture_file("file.txt")

## Setup

add elabs_matchers to your Gemfile:

```ruby
gem "elabs_matchers", :git => "git://github.com/elabs/elabs_matchers.git"
```

if you"re using Spork gem you need to tell bundler not to require the files for you:

```ruby
gem "elabs_matchers", :git => "git://github.com/elabs/elabs_matchers.git", :require => false
```

then you'll require them inside your spork prefork block:

```ruby
Spork.prefork do
  ...
  require "elabs_matchers"
  ...
end
```

## Development

See devlopment.rb

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
