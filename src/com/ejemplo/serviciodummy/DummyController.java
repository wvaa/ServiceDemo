package com.ejemplo.serviciodummy;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@RestController
public class DummyController {


    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // El tipo de retorno ahora es la clase 'Estado'
    @GetMapping("/estado")
    public Estado obtenerEstado() {

        // 1. Obtenemos la fecha y hora actual
        String fechaHoraActual = LocalDateTime.now().format(FORMATTER);

        // 2. Creamos una instancia de nuestro objeto de respuesta
        Estado respuesta = new Estado(
                "El servicio esta activo y funcionando correctamente.",
                true,
                fechaHoraActual
        );

        // 3. Spring Boot automáticamente convierte el objeto 'respuesta' a JSON
        return respuesta;
    }
}
