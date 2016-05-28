module ShakeItUp
  class API < Grape::API
    resource :flavor do
      get '/' do
        flavors = Flavor.all
        present flavors, :with => Entities::Flavor
      end

      params do
        requires :id, type: Integer, desc: 'Identity.'
      end
      get '/:id', requirements: {id: /[0-9]*/} do
        flavor = Flavor.get(params[:id])
        error!('flavor not found', 404) unless flavor
        present flavor, :with => Entities::Flavor
      end

      params do
        requires :name, type: String
      end
      post '/' do
        display_name = params[:name]
        slug_name = slugify(display_name)
        Flavor.create(:name => slug_name, :display_name => display_name)
      end

      params do
        requires :id, type: Integer, desc: 'Identity.'
        requires :name, type: String
      end
      patch '/:id' do
        flavor = Flavor.get(params[:id])
        error!('Flavor not found', 404) unless flavor
        new_name = params[:name]
        new_slug_name = slugify(new_name)
        Flavor.update(:name => new_slug_name, :display_name => new_name)
      end

      params do
        requires :id, type: Integer, desc: 'Identity.'
      end
      delete '/:id' do
        flavor = Flavor.get(params[:id])
        error!('flavor not found', 404) unless flavor
        Flavor.destroy
      end

    end
  end
end