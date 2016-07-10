module Entities
  class Group < Grape::Entity
    root :groups
    expose :id
    expose :name
  end
end