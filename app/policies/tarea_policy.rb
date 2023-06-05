class TareaPolicy
    attr_reader :tarea, :usuario_act
  
    def initialize(tarea, usuario_act)
      @tarea = tarea
      @usuario_act = usuario_act
    end

    def crear_tarea?
        @usuario_act.usuario_tipo == "Líder"
    end
    
    def cambiar_estado_tarea?
        @tarea. == usuario_act.lider
      end
  end