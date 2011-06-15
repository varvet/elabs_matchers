module ElabsMatchers
  module Orm
    def reload(model)
      model.class.find(model.id)
    end

    def save_and_reload(model)
      model.save!
      reload(model)
    end
  end
end

RSpec.configure do |config|
  config.include ElabsMatchers::Orm
end

