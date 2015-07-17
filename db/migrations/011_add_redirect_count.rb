Sequel.migration do
  change do
    alter_table(:articles) do
      add_column (:clicks), Integer, default: 0
    end
  end
end
