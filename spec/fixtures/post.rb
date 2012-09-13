require "active_model"

module ElabsMatchers
  module Orm
    class Post
      extend ActiveModel::Naming
      include ActiveModel::Validations

      attr_accessor :title, :body, :signature, :category, :price, :published_on, :visible, :authors, :co_author
      validates_presence_of :title
      validates_presence_of :body
      validates_presence_of :published_on
      validates_presence_of :authors
      validates_presence_of :co_author
      validates_inclusion_of :category, :in => %w[sci-fi fantasy thriller]
      validates_inclusion_of :visible, :in => [true, false]
      validates_numericality_of :price

      class << self
        def find(id)
          new(:title => @@persisted_post.title)
        end

        def create(attributes = {})
          @@persisted_post = new(attributes)
        end
      end

      def initialize(attributes = {})
        attributes.each do |name, value|
          self.send(:"#{name}=", value)
        end
      end

      def save!
      end

      def id
      end
    end
  end
end
