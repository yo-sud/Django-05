package com.example.demo.controller;

import com.example.demo.dto.PerfilRequestDTO;
import com.example.demo.entity.Perfil;
import com.example.demo.service.PerfilService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/perfiles")
public class PerfilController {

    @Autowired
    private PerfilService perfilService;

    @GetMapping
    public ResponseEntity<List<Perfil>> listarTodos() {
        List<Perfil> perfiles = perfilService.findAll();
        return ResponseEntity.ok(perfiles);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Perfil> obtenerPorId(@PathVariable Long id) {
        Perfil perfil = perfilService.findByIdOrThrow(id);
        return ResponseEntity.ok(perfil);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<Perfil> obtenerPorUsuarioId(@PathVariable Long usuarioId) {
        Perfil perfil = perfilService.findByUsuarioId(usuarioId);
        if (perfil == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(perfil);
    }

    @PostMapping("/usuario/{usuarioId}")
    public ResponseEntity<Perfil> crearParaUsuario(@PathVariable Long usuarioId, @Valid @RequestBody PerfilRequestDTO request) {
        Perfil perfil = new Perfil(request.getNombreCompleto(), request.getDireccion(), request.getTelefono());
        Perfil saved = perfilService.saveForUsuario(usuarioId, perfil);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Perfil> actualizar(@PathVariable Long id, @Valid @RequestBody PerfilRequestDTO request) {
        Perfil perfilDetails = new Perfil(request.getNombreCompleto(), request.getDireccion(), request.getTelefono());
        Perfil perfil = perfilService.update(id, perfilDetails);
        return ResponseEntity.ok(perfil);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        perfilService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}