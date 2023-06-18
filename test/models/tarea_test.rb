# frozen_string_literal: true

require 'test_helper'

class TareaTest < ActiveSupport::TestCase
  test 'Nueva tarea deberia crearse con estado Pendiente' do
    @tarea = Tarea.new
    assert @tarea.estado == 'Pendiente'
  end

  test 'No puedo cambiar estado de tarea de Pendiente a Finalizado' do
    @tarea = Tarea.new
    assert_equal false, @tarea.cambiar_estado('Finalizado')
  end

  test 'Puedo cambiar estado de tarea de Pendiente a Cumplido' do
    @tarea = Tarea.new
    assert @tarea.cambiar_estado('Cumplido')
  end

  test 'No puedo cambiar estado de tarea a uno no valido' do
    @tarea = Tarea.new
    assert_equal false, @tarea.cambiar_estado('No existe')
  end
end
