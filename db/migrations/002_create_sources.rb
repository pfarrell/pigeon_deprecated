Sequel.migration do
  change do
    create_table(:sources) do
      primary_key :id
      String :type
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
