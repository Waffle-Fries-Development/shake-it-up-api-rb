module ShakeItUp
  class API < Grape::API
    resource :groups do
      desc 'Return list of users'
      get '/' do
        Group.all
      end
    end
  end
end
