class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.string :tipo_log
      t.string :proyecto_id
      t.string :subject_id
      t.string :mensaje
      t.string :fecha_hora

      t.timestamps
    end
  end
end
