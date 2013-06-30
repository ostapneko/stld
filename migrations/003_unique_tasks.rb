Sequel.migration do
  change do
    create_table(:unique_tasks) do
      primary_key :id
      String :description, null: false, unique: true
      String :status, null: false
    end
  end
end
