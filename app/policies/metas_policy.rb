class MetasPolicy
    attr_reader :meta, :usuario
  
    def initialize(meta, usuario)
        @meta = meta
        @usuario = usuario
    end

    def create?
        @usuario_act.usuario_tipo == "Gerente"
    end

    def update?
        @usuario_act.usuario_tipo == "Gerente"
    end
  end