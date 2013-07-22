Sequel.migration do
  change do
    create_table(:recurring_tasks) do
      primary_key :id
      String  :description     , null: false , unique: true
      Integer :frequency       , null: false , default: 1
      Boolean :enabled         , null: false , default: true
      String  :status          , null: false , default: "todo"
      Integer :started_at_week , null: false
      Integer :started_at_year , null: false
    end
  end
end
