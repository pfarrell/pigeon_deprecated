Sequel.migration do
  change do
    alter_table(:articles) do
      add_column :marked, TrueClass
    end
  end
end
