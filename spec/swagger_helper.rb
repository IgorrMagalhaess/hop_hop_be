# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Trip API V1',
        version: 'v1'
      },
      paths: {},
      components: {
        schemas: {
          not_found: {
            type: 'object',
            properties: {
              message: { type: :string }
            }
          },
          trip: {
              type: "object",
              properties: {
                name: {
                  type: :string,
                  example: "Disneyland in Tokyo!"
                },
                location: {
                  type: :string,
                  example: "Tokyo, Japan"
                },
                start_date: {
                  type: :date_time,
                  example: "Wed, 24 Apr 2024 06:42:40.385053000 UTC +00:00"
                },
                end_date: {
                  type: :date_time,
                  example: "Mon, 24 Jun 2024 14:15:24.410940000 UTC +00:00",
                },
                status: {
                  type: :string,
                  example: "in_progress"
                },
                total_budget: {
                  type: :integer,
                  example: 4676
                },
                user_id: {
                  type: :integer,
                  example: 1
                }
              }
            }
          },
          accommodations: {
            type: "object",
            required: [:trip_id, :name, :address, :lat, :lon, :type_of_accommodation, :check_in, :check_out, :expenses],
            properties: {
              trip_id: {
                type: :integer,
                example: 1
              },
              name: {
                type: :string,
                example: "Mariott Monterey Bay"
              },
              address: {
                type: :string,
                example: "7836 Haywood Throughway"
              },
              lat: {
                type: :float,
                example: 26.885830851487825
              },
              lon: {
                type: :float,
                example: -162.29136075180418
              },
              type_of_accommodation: {
                type: :string,
                example: "Hotel"
              },
              check_in: {
                type: :datetime,
                example: "Wed, 24 Apr 2024 06:42:40.385053000 UTC +00:00"
              },
              check_out: {
                type: :datetime,
                example: "Mon, 24 Jun 2024 14:15:24.410940000 UTC +00:00"
              },
              expenses: {
                type: :integer,
                example: 3000
              }
            }
          }
        },
      },
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
