Sequel.migration do
  change do
    alter_table(:sources) do
      add_column (:color), String
    end
  end
end
