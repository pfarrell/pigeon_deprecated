Sequel.migration do
  change do
    create_table(:articles_links) do
      primary_key :id
      Fixnum :article_id
      Fixnum :link_id
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
