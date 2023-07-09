class AddBorradoToTareas < ActiveRecord::Migration[7.0]
  def change
    add_column :tareas, :borrado, :boolean, null: false, default: false
  end
end
