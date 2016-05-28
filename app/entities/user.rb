module Entities
  class User < Grape::Entity
    format_with(:timestamp) { |date| date.iso8601 }

    expose :id
    expose :username
    expose :first_name
    expose :last_name
    expose :created_at, :updated_at, format_with: :timestamp
  end
end
