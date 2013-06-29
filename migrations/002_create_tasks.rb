Sequel.migration do
  change do
    create_table(:tasks) do
      primary_key :id
      String :description, null: false
      String :status, null: false
      Integer :frequency
      foreign_key(:started_at_sprint_id,
                  :sprints,
                  key: :id,
                  index: true)
    end
  end
end
