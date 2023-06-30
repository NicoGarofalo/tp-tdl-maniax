class AddBorradoToMeta < ActiveRecord::Migration[7.0]
  def change
    add_column :meta, :borrado, :boolean, null: false, default: false
  end
end
