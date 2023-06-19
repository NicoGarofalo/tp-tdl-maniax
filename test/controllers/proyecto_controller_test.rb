# frozen_string_literal: true

require 'test_helper'
class ProyectoControllerTest < ActionDispatch::IntegrationTest
  test 'No permite crear proyecto con usuario que no sea Gerente' do
    nuevo_usuario = Usuario.new(
      usuario_tipo: 'Revisor',
      nombre: 'Nico',
      apellido: 'Revisor',
      email: 'nicog@example.com',
      password: 'pw123452023',
      password_confirmation: 'pw123452023'
    )
    usuario_lider = Usuario.new(
      usuario_tipo: 'Lider',
      nombre: 'Nico',
      apellido: 'Lider',
      email: 'nicog@example.com',
      password: 'pw123452023',
      password_confirmation: 'pw123452023'
    )
    nuevo_usuario.save
    usuario_lider.save

    post iniciar_sesion_url, params: { email: nuevo_usuario.email, password: nuevo_usuario.password }
    params_post = {
      proyecto: {
        lider_id: 2,
        fecha_vencimiento: '2023-06-30',
        nombre: 'Nuevo Proyecto',
        descripcion: 'Descripción del proyecto'
      }
    }
    assert_raises Pundit::NotAuthorizedError do
      post proyectos_url, params: params_post
    end
  end
end
