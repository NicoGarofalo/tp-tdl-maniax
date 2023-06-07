class ProyectoPolicy
    attr_reader :proyecto, :usuario
  
    def initialize(usuario, proyecto)
        @usuario = usuario
        @proyecto = proyecto
    end

    def create?
        @usuario.usuario_tipo == "Gerente"
    end

    # El estado cumplido != finalizado para proyecto? Para que lo usariamos?
    def update?
        @usuario.usuario_tipo == "Gerente" && @proyecto.estado == "Finalizado"
    end

    def show?
        @usuario.usuario_tipo == "Gerente" || @usuario.usuario_tipo == "Lider"
    end
  end