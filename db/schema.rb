# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_04_161212) do
  create_table "logs", force: :cascade do |t|
    t.string "tipo_log"
    t.integer "proyecto_id", null: false
    t.integer "subject_id", null: false
    t.text "mensaje"
    t.datetime "fecha_hora"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meta", force: :cascade do |t|
    t.integer "proyecto_id", null: false
    t.date "fecha_vencimiento"
    t.string "nombre"
    t.text "descripcion"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proyecto_id"], name: "index_meta_on_proyecto_id"
  end

  create_table "metas", force: :cascade do |t|
    t.integer "proyecto_id", null: false
    t.date "fecha_vencimiento"
    t.string "nombre"
    t.text "descripcion"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proyecto_id"], name: "index_metas_on_proyecto_id"
  end

  create_table "notificaciones", force: :cascade do |t|
    t.integer "usuario_id", null: false
    t.string "notificacion_tipo"
    t.text "mensaje"
    t.datetime "fecha_hora"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_notificaciones_on_usuario_id"
  end

  create_table "proyectos", force: :cascade do |t|
    t.integer "gerente_id", null: false
    t.integer "lider_id", null: false
    t.date "fecha_vencimiento"
    t.string "nombre"
    t.text "descripcion"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gerente_id"], name: "index_proyectos_on_gerente_id"
    t.index ["lider_id"], name: "index_proyectos_on_lider_id"
  end

  create_table "tareas", force: :cascade do |t|
    t.integer "meta_id", null: false
    t.integer "revisor_id", null: false
    t.integer "integrante_id", null: false
    t.date "fecha_vencimiento"
    t.string "nombre"
    t.text "descripcion"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["integrante_id"], name: "index_tareas_on_integrante_id"
    t.index ["meta_id"], name: "index_tareas_on_meta_id"
    t.index ["revisor_id"], name: "index_tareas_on_revisor_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "usuario_tipo"
    t.string "nombre"
    t.string "apellido"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "meta", "proyectos"
  add_foreign_key "metas", "proyectos"
  add_foreign_key "notificaciones", "usuarios"
  add_foreign_key "proyectos", "usuarios", column: "gerente_id"
  add_foreign_key "proyectos", "usuarios", column: "lider_id"
  add_foreign_key "tareas", "meta", column: "meta_id"
  add_foreign_key "tareas", "usuarios", column: "integrante_id"
  add_foreign_key "tareas", "usuarios", column: "revisor_id"
end
