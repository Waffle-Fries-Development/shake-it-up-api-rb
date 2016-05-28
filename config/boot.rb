ENV['RACK_ENV'] ||= 'development'
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'

require 'data_mapper' # metagem, requires common plugins too.
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

# Load the helpers
Dir['./app/helper/*.rb'].each { |f| require f }

# DataMapper
if ENV['RACK_ENV'] == 'production'
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# Load the models
Dir['./app/model/*.rb'].each { |f| require f }
# Load the entities
Dir['./app/entities/*.rb'].each { |f| require f }

ENV['SESSION_SECRET'] ||= 'a9f14e75bf8bcec559503d78a08c740ddbc83af322a52886464d473e2d3a9f44'

module ShakeItUp

  class API < Grape::API
    version 'v1', using: :header, vendor: 'shakeitup'
    default_format :json
    format :json
    do_not_route_options!
  end

  class SecureAPI < Grape::API
    version 'v1', using: :header, vendor: 'shakeitup'
    default_format :json
    format :json
    do_not_route_options!

    before do
      set_current_user
      authenticate_request
    end

    helpers do
      def set_current_user
        if decoded_auth_token
          @current_user ||= User.find_by_id(decoded_auth_token[:user_id])
        end
      end

      def authenticate_request
        if auth_token_expired?
          error!({message: 'Not authorized'}, 401)
        elsif !@current_user
          error!({message: 'Not authorized'}, 401)
        end
      end

      def decoded_auth_token
        @decoded_auth_token ||= AuthToken.decode(http_auth_header_content)
      end

      def auth_token_expired?
        decoded_auth_token && decoded_auth_token.expired?
      end

      def http_auth_header_content
        return @http_auth_header_content if defined? @http_auth_header_content
        @http_auth_header_content = begin
          if request.headers['Api-Token'].present?
            request.headers['Api-Token'].split(' ').last
          else
            nil
          end
        end
      end
    end

  end

  class App < Grape::API

    route :any, '*path' do
      error!({message: 'Not Found'}, 404)
    end

    mount ShakeItUp::API
    mount ShakeItUp::SecureAPI
  end

end

# Load the controllers
Dir['./app/controller/*.rb'].each { |f| require f }
