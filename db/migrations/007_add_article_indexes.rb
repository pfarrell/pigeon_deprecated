Sequel.migration do
  change do
    alter_table(:articles) do
      add_index(:url)
    end
  end
end
