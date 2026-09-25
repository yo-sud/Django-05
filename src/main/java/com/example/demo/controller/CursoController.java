package com.example.demo.controller;

import com.example.demo.dto.CursoRequestDTO;
import com.example.demo.entity.Curso;
import com.example.demo.service.CursoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cursos")
public class CursoController {

    @Autowired
    private CursoService cursoService;

    @GetMapping
    public ResponseEntity<List<Curso>> listarTodos() {
        return ResponseEntity.ok(cursoService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Curso> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(cursoService.findByIdOrThrow(id));
    }

    @PostMapping
    public ResponseEntity<Curso> crear(@Valid @RequestBody CursoRequestDTO request) {
        Curso curso = new Curso(request.getNombre(), request.getCreditos());
        Curso saved = cursoService.save(curso);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Curso> actualizar(@PathVariable Long id, @Valid @RequestBody CursoRequestDTO request) {
        Curso cursoDetails = new Curso(request.getNombre(), request.getCreditos());
        return ResponseEntity.ok(cursoService.update(id, cursoDetails));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        cursoService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}