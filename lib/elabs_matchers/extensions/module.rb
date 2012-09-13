##
#
# Allows you to include a module to be available in your
# rspec tests from without the module it self.
#
# @param [Hash] rspec options     A hash of options which instructs rspec on how (and where) to include the module.
#
# Example:
# module MyMatchers
#   rspec :type => :request
#
#   matcher :have_image do |alt|
#     ...
#   end
# end
#

Module.class_eval do
  def rspec(options={})
    RSpec.configure do |config|
      config.include self, options
    end
  end
end
