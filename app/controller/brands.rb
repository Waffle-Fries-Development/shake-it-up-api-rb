module ShakeItUp
  class API < Grape::API
    resource :brand do
      get '/' do
        brands = Brand.all
        present brands, :with => Entities::Brand
      end

      params do
        requires :id, type: Integer, desc: 'Identity.'
      end
      get '/:id', requirements: {id: /[0-9]*/} do
        brand = Brand.get(params[:id])
        error!('Brand not found', 404) unless brand
        present brand, :with => Entities::Brand
      end

      params do
        requires :name, type: String
      end
      post '/' do
        display_name = params[:name]
        slug_name = slugify(display_name);
        brand = Brand.create(:name => slug_name, :display_name => display_name)
        present brand, :with => Entities::Brand
      end

      params do
        requires :id, type: Integer, desc: 'Identity.'
        requires :name, type: String
      end
      patch '/:id' do
        brand = Brand.get(params[:id])
        error!('Brand not found', 404) unless brand
        new_name = params[:name]
        new_slug_name = slugify(new_name)
        brand.update(:name => new_slug_name, :display_name => new_name)
        present brand, :with => Entities::Brand
      end

      params do
        requires :id, type: Integer, desc: 'Identity.'
        requires :flavor, type: String
      end
      patch '/:id/add_flavor/:flavor', requirements: {id: /[0-9]*/, flavor: /[a-z-]*/} do
        brand = Brand.get(params[:id])
        error!('Brand not found', 404) unless brand

        flavor = Flavor.first(:name => params[:flavor])
        if not flavor
          flavor = Flavor.first(:display_name => params[:flavor])
        end
        error!("#{params[:flavor]} Flavor not found", 404) unless flavor

        brand.add_flavor(flavor).save

        redirect "/brand/#{brand.id}", permanent: true
      end

      params do
        requires :id, type: Integer, desc: 'Identity.'
      end
      delete '/:id' do
        brand = Brand.get(params[:id])
        error!('Brand not found', 404) unless brand
        brand.delete_flavors.save!
        brand.destroy
      end

    end

  end
end