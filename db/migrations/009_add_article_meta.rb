Sequel.migration do
  up do
    alter_table(:articles) do
      add_column (:meta), :json, default: Sequel.pg_json({})
    end
  end

  down do
    alter_table(:articles) do
      drop_column(:meta)
    end
  end
end
