module CoffeeBean
  module V1
    module Resources
      class Datastore
        def initialize(client)
          @client = client
        end

        def objects
          @_objects ||= V1::Resources::Datastore::Objects.new(@client)
        end
      end
    end
  end
end
