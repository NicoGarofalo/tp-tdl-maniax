class TareaPolicy
    attr_reader :tarea, :usuario_act
  
    def initialize(tarea, usuario_act)
      @tarea = tarea
      @usuario_act = usuario_act
    end

    def create?
        @usuario_act.usuario_tipo == "Líder"
    end
    
    def update?
        es_revisor = @tarea.revisor_id == @usuario_act.id && @usuario_act.usuario_tipo == "Revisor"
        es_integrante = @tarea.integrante_id == @usuario_act.id && @usuario_act.usuario_tipo == "Integrante"

        es_revisor || es_integrante
      end
  end