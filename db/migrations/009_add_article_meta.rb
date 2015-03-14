Sequel.migration do
  change do
    alter_table(:articles) do
      add_column (:meta), :json, default:   Sequel.pg_json({})
    end
  end
end
