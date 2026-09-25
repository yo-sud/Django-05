package com.example.demo.controller;

import com.example.demo.dto.CursoRequestDTO;
import com.example.demo.dto.EstudianteRequestDTO;
import com.example.demo.entity.Curso;
import com.example.demo.entity.Estudiante;
import com.example.demo.service.CursoService;
import com.example.demo.service.EstudianteService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/estudiantes")
public class EstudianteController {

    @Autowired
    private EstudianteService estudianteService;

    @Autowired
    private CursoService cursoService;

    @GetMapping
    public ResponseEntity<List<Estudiante>> listarTodos() {
        return ResponseEntity.ok(estudianteService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Estudiante> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(estudianteService.findByIdOrThrow(id));
    }

    @PostMapping
    public ResponseEntity<Estudiante> crear(@Valid @RequestBody EstudianteRequestDTO request) {
        Estudiante estudiante = new Estudiante(request.getNombre(), request.getEmail());
        Estudiante saved = estudianteService.save(estudiante);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Estudiante> actualizar(@PathVariable Long id, @Valid @RequestBody EstudianteRequestDTO request) {
        Estudiante estudianteDetails = new Estudiante(request.getNombre(), request.getEmail());
        return ResponseEntity.ok(estudianteService.update(id, estudianteDetails));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        estudianteService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    // Inscribir estudiante en curso
    @PostMapping("/{estudianteId}/cursos/{cursoId}")
    public ResponseEntity<Estudiante> inscribirEnCurso(@PathVariable Long estudianteId, @PathVariable Long cursoId) {
        return ResponseEntity.ok(estudianteService.inscribirEnCurso(estudianteId, cursoId));
    }

    // Desinscribir estudiante de curso
    @DeleteMapping("/{estudianteId}/cursos/{cursoId}")
    public ResponseEntity<Estudiante> desinscribirDeCurso(@PathVariable Long estudianteId, @PathVariable Long cursoId) {
        return ResponseEntity.ok(estudianteService.desinscribirDeCurso(estudianteId, cursoId));
    }

    // Listar cursos de un estudiante
    @GetMapping("/{estudianteId}/cursos")
    public ResponseEntity<List<Curso>> obtenerCursos(@PathVariable Long estudianteId) {
        return ResponseEntity.ok(estudianteService.obtenerCursosDeEstudiante(estudianteId));
    }
}