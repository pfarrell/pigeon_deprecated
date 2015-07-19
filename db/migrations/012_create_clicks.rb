Sequel.migration do
  change do
    create_table(:clicks) do
      primary_key :id
      Integer :article_id
      DateTime :created_at
    end
  end
end
