Sequel.migration do
  change do
    create_table(:recurring_tasks) do
      primary_key :id
      String  :description, null: false, unique: true
      Integer :frequency  , null: false, default: 1
      Boolean :enabled    , null: false, default: true
      String  :status     , null: false, default: "todo"
      foreign_key(:started_at_sprint_id,
                  :sprints,
                  key: :id,
                  index: true)
    end
  end
end
