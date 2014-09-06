Sequel.migration do
  change do
    create_table(:rss_feeds) do
      foreign_key :id, :sources
      String :url
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
