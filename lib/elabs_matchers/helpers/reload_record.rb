module ElabsMatchers
  module Helpers
    module ReloadRecord
      rspec :type => :model

      ##
      #
      # Finds the record from the database and return a new instance for that record.
      #
      # @param [Object] record      An instance of an ORM record
      #
      # Example:
      # reload(post)

      def reload(record)
        record.class.find(record.id)
      end

      ##
      #
      # Saves the record and fetches it from the database and return a new instance for that record.
      #
      # @param [Object] record      An instance of an ORM record
      #
      # Example:
      # save_and_reload(post)

      def save_and_reload(record)
        record.save!
        reload(record)
      end
    end
  end
end

