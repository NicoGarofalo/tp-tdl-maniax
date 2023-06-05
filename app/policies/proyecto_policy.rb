class ProyectoPolicy
    attr_reader :proyecto, :usuario
  
    def initialize(usuario, proyecto)
        @usuario = usuario
        @proyecto = proyecto
    end

    def create?
        @usuario.usuario_tipo == "Gerente"
    end
  end