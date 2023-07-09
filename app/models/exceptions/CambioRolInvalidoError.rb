class CambioRolInvalido < StandardError
    def initialize(message = "El cambio de rol no es válido")
        super(message)
    end
end