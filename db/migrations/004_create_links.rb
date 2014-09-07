Sequel.migration do
  change do
    create_table(:links) do
      primary_key :id
      String :title
      String :type
      String :url
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
