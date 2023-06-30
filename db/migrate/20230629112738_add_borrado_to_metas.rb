class AddBorradoToMetas < ActiveRecord::Migration[7.0]
  def change
    add_column :metas, :borrado, :boolean, null: false, default: false
  end
end
