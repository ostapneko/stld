Sequel.migration do
  change do
    create_table(:sprints) do
      Integer :year, null: false
      Integer :week, null: false

      unique([:year, :week])
      index :year
      index :week
    end
  end
end
