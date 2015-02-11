Sequel.migration do
  change do
    create_table(:captures) do
      primary_key :id
      Fixnum :article_id
      String :url
      DateTime :date
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
