Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id
      String :title
      Fixnum :source_id
      DateTime :date
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
