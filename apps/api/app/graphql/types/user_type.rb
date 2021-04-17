module Types
  class UserType < Types::BaseObject
    field :uuid, String, null: false
    field :email, String, null: false
    field :username, String, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :timezone, String, null: true
  end
end
