require 'yaml'

brands = YAML.load_file(File.absolute_path('db/fixtures/brands.yml'))
flavors = YAML.load_file(File.absolute_path('db/fixtures/flavors.yml'))

brands.each { |brand| Brand.create(:name => slugify(brand), :display_name => brand) }
shakeology_brand = Brand.first(:display_name => 'Shakeology')
flavors.each { |flavor| Flavor.create(:name => slugify(flavor), :display_name => flavor, :brands => [shakeology_brand]) }
