module CoffeeBean
  module V1
    module Resources
      class Datastore::Objects < Resource
        def create(schema_name, **attributes)
          post build_path(schema_name), body: attributes
        end

        private
        def build_path(schema_name, id = nil)
          path = "v1/marketing/datastore/schemas/#{schema_name}/objects"
          path += "/#{id}" if id.present?
          path
        end
      end
    end
  end
end
