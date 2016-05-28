module Entities
  class Flavor < Grape::Entity
    format_with(:timestamp) { |date| date.iso8601 }

    expose :id
    expose :name
    expose :display_name
    expose :created_at, :updated_at, format_with: :timestamp
  end
end