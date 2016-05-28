module ShakeItUp
  class SecureAPI < Grape::API
    resource :me do
      get '/' do
        # authenticate_request
        present @current_user, :with => Entities::User
      end
    end
    resource :user do
      desc 'Return list of users'
      get '/' do
        if !@current_user.has_group('admin')
          error!({message: 'Not authorized'}, 401)
        end
        # authenticate_request
        users = User.all
        present users, :with => Entities::User
      end
      get '/test' do
        if @current_user.has_group('admin')
          error!({message: 'Not authorized'}, 401)
        end
        {has_group: @current_user.has_group('admin')}
      end
    end
  end
end
