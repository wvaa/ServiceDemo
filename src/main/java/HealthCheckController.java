import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthCheckController {

    @GetMapping("/health")
    public ResponseEntity<String> checkHealth() {
        // Se puede agregar lógica para verificar la conexión a DB, etc.
        return ResponseEntity.ok("OK");
    }
}