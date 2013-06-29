Sequel.migration do
  change do
    create_table(:sprints_tasks) do
      foreign_key(:sprint_id,
                  :sprints,
                  key: :id,
                  index: true,
                  on_delete: :cascade)
      foreign_key(:task_id,
                  :tasks,
                  key: :id,
                  index: true,
                  null: false,
                  on_delete: :cascade)
      unique([:sprint_id, :task_id])
    end
  end
end
