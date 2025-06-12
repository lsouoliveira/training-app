module CoffeeBean
  module V1
    module Resources
      class Datastore::Objects < Resource
        def create(schema_name, **attributes)
          post build_path(schema_name), body: attributes
        end

        def list(schema_name, **params)
          response = get build_path(schema_name, nil, **params)

          V1::Objects::Collection.from_json(response.body)
        end

        def update(schema_name, id, **attributes)
          put build_path(schema_name, id), body: attributes
        end

        private
        def build_path(schema_name, id = nil, **params)
          path = "v1/marketing/datastore/schemas/#{schema_name}/objects"
          path += "/#{id}" if id.present?
          path += "?#{params.to_query}" if params.present?
          path
        end
      end
    end
  end
end
