Sequel.migration do
  change do
    alter_table(:articles) do
      add_index(:title)
    end
  end
end
