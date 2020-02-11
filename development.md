## Setting up:

1. Fork the gem
2. Clone you fork to your local machine
3. Run:
   gem install bundler
   bundle install
   rspec

## Pull requests:

Pull requests are appreciated. Before submitting please consider the following:

* Public methods are documented.
* `rake yard` runs without warnings.
* Matchers are using the "class syntax", that is, not the DSL.
* Use double quotes ("), not single quotes (') whenever possible.
  Exceptions are when writing copy, "It's a fine day" and "Expected '#{actual}' to be '#{expected}'." is also fine.
* When writing matches? methods, consider writing does_not_match? as well.
  This is important when writing Capybara matchers since failing to do so will cause problems with
  specs that are rune with asynchronous communication going on (AJAX).
* Try to follow the pattern of a selector and a selector_type method in each matcher
* If possible, allow the user to override the selector and selector type using the configure syntax.
* Test your methods using the same pattern as existing specs.

Thank you for helping out!
