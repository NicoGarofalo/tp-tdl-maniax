class UsuariosPolicy
    attr_reader :usuario_act, :usuario
  
    def initialize(usuario, usuario_act)
        @usuario = usuario
        @usuario_act = usuario_act
    end

    def create?
        @usuario_act.usuario_tipo == "Gerente"
    end

    def update?
        @usuario == @usuario_act || @usuario_act.usuario_tipo == "Gerente"
    end
  end