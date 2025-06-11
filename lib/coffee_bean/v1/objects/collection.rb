module CoffeeBean
  module V1
    module Objects
      class Collection
        attr_accessor :total, :count, :offset, :data

        def initialize(opts = {})
          @total = opts[:total]
          @count = opts[:count]
          @offset = opts[:offset]
          @data = opts[:data]
        end

        def self.from_json(json)
          new(
            total: json["total"],
            count: json["count"],
            offset: json["offset"],
            data: json["results"] || []
          )
        end
      end
    end
  end
end
