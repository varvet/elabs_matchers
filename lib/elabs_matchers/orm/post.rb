class Post
  attr_accessor :title

  class << self
    def find(id)
      @@persisted_post
    end

    def create(attributes = {})
      @@persisted_post = new(attributes)
    end
  end

  def initialize(attributes = {})
    self.title = attributes[:title]
  end

  def save!
  end

  def id
  end
end