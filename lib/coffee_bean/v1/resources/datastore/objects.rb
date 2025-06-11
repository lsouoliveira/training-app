module CoffeeBean
  module V1
    module Resources
      module Datastore
        class Objects < Resource
          def create(schema_name, **attributes)
            post build_path(schema_name), body: attributes
          end

          def list(schema_name)
            response = get build_path(schema_name)
            response.body
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
end
