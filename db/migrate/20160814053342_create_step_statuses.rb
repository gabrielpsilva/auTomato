class CreateStepStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :step_statuses do |t|
      t.string :name


    end
  end
end