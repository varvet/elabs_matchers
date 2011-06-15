class Post
  attr_accessor :title

  class << self
    def find(id)
      new(:title => @@persisted_post.title)
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