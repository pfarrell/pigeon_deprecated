Sequel.migration do
  change do
    create_table(:rss_feeds) do
      primary_key :id
      Fixnum :source_id
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
