package com.example.demo.controller;

import com.example.demo.dto.UsuarioRequestDTO;
import com.example.demo.entity.Usuario;
import com.example.demo.service.UsuarioService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping
    public ResponseEntity<List<Usuario>> listarTodos() {
        List<Usuario> usuarios = usuarioService.findAll();
        return ResponseEntity.ok(usuarios);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Usuario> obtenerPorId(@PathVariable Long id) {
        Usuario usuario = usuarioService.findByIdOrThrow(id);
        return ResponseEntity.ok(usuario);
    }

    @PostMapping
    public ResponseEntity<Usuario> registrar(@Valid @RequestBody UsuarioRequestDTO request) {
        Usuario usuario = new Usuario(request.getUsername(), request.getPassword());
        
        if (request.getPerfil() != null) {
            com.example.demo.entity.Perfil perfil = new com.example.demo.entity.Perfil(
                request.getPerfil().getNombreCompleto(),
                request.getPerfil().getDireccion(),
                request.getPerfil().getTelefono()
            );
            usuario = usuarioService.saveWithPerfil(usuario, perfil);
        } else {
            usuario = usuarioService.save(usuario);
        }
        
        return ResponseEntity.status(HttpStatus.CREATED).body(usuario);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Usuario> actualizar(@PathVariable Long id, @Valid @RequestBody UsuarioRequestDTO request) {
        Usuario usuarioDetails = new Usuario(request.getUsername(), request.getPassword());
        Usuario usuario = usuarioService.update(id, usuarioDetails);
        return ResponseEntity.ok(usuario);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        usuarioService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}