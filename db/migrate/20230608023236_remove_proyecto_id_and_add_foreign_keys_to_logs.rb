# frozen_string_literal: true

class RemoveProyectoIdAndAddForeignKeysToLogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :logs, :proyecto_id
    add_reference :logs, :obligatorio, foreign_key: { to_table: :usuarios }
    add_reference :logs, :opcional, foreign_key: { to_table: :usuarios }
  end
end
