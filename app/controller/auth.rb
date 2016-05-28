module ShakeItUp
  class API < Grape::API
    resource :auth do
      params do
        requires :username, type: String
        requires :password, type: String
      end
      post '/' do
        username = params[:username]
        password = params[:password]

        if user = User.authenticate(username, password)
          {auth_token: user.generate_auth_token}
        else
          error!({message: 'Invalid username and/or password'}, 401)
        end
      end

      params do
        requires :auth_token, type: String
      end
      get '/' do
        AuthToken.decode(params[:auth_token])
      end
    end
  end
end