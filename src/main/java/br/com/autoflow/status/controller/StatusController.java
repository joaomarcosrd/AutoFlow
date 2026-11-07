package br.com.autoflow.status.controller;

import br.com.autoflow.status.dto.StatusResponse;
import br.com.autoflow.status.service.StatusService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/status")
public class StatusController {

    private final StatusService statusService;

    public StatusController(StatusService statusService) {
        this.statusService = statusService;
    }

    @GetMapping
    public ResponseEntity<StatusResponse> obterStatus() {
        return ResponseEntity.ok(statusService.consultarStatusBanco());
    }
}
