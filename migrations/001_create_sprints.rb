Sequel.migration do
  change do
    create_table(:sprints) do
      primary_key :id
      Integer :week_number, null: false
      Integer :year, null: false
    end
  end
end
