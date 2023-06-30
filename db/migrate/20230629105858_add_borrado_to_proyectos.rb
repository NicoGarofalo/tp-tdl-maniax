class AddBorradoToProyectos < ActiveRecord::Migration[7.0]
  def change
    add_column :proyectos, :borrado, :boolean, null:false, default: false
  end
end
