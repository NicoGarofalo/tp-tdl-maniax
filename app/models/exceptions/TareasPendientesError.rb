class TareasPendientes < StandardError
    def initialize(message = "El usuario aun tiene tareas pendientes")
        super(message)
    end
end