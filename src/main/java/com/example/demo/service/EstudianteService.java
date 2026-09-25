package com.example.demo.service;

import com.example.demo.entity.Curso;
import com.example.demo.entity.Estudiante;
import com.example.demo.repository.CursoRepository;
import com.example.demo.repository.EstudianteRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class EstudianteService {

    @Autowired
    private EstudianteRepository estudianteRepository;

    @Autowired
    private CursoRepository cursoRepository;

    public List<Estudiante> findAll() {
        return estudianteRepository.findAll();
    }

    public Optional<Estudiante> findById(Long id) {
        return estudianteRepository.findById(id);
    }

    public Estudiante findByIdOrThrow(Long id) {
        return estudianteRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Estudiante no encontrado con ID: " + id));
    }

    public Estudiante save(@Valid Estudiante estudiante) {
        if (estudianteRepository.existsByEmail(estudiante.getEmail())) {
            throw new IllegalArgumentException("El email ya existe: " + estudiante.getEmail());
        }
        return estudianteRepository.save(estudiante);
    }

    public Estudiante update(Long id, @Valid Estudiante estudianteDetails) {
        Estudiante estudiante = findByIdOrThrow(id);
        if (!estudiante.getEmail().equals(estudianteDetails.getEmail()) &&
            estudianteRepository.existsByEmail(estudianteDetails.getEmail())) {
            throw new IllegalArgumentException("El email ya existe: " + estudianteDetails.getEmail());
        }
        estudiante.setNombre(estudianteDetails.getNombre());
        estudiante.setEmail(estudianteDetails.getEmail());
        return estudianteRepository.save(estudiante);
    }

    public void deleteById(Long id) {
        if (!estudianteRepository.existsById(id)) {
            throw new EntityNotFoundException("Estudiante no encontrado con ID: " + id);
        }
        estudianteRepository.deleteById(id);
    }

    // Inscribir estudiante en curso
    public Estudiante inscribirEnCurso(Long estudianteId, Long cursoId) {
        Estudiante estudiante = findByIdOrThrow(estudianteId);
        Curso curso = cursoRepository.findById(cursoId)
                .orElseThrow(() -> new EntityNotFoundException("Curso no encontrado con ID: " + cursoId));

        if (estudiante.getCursos().contains(curso)) {
            throw new IllegalArgumentException("El estudiante ya está inscrito en este curso");
        }

        estudiante.addCurso(curso);
        return estudianteRepository.save(estudiante);
    }

    // Desinscribir estudiante de curso
    public Estudiante desinscribirDeCurso(Long estudianteId, Long cursoId) {
        Estudiante estudiante = findByIdOrThrow(estudianteId);
        Curso curso = cursoRepository.findById(cursoId)
                .orElseThrow(() -> new EntityNotFoundException("Curso no encontrado con ID: " + cursoId));

        if (!estudiante.getCursos().contains(curso)) {
            throw new IllegalArgumentException("El estudiante no está inscrito en este curso");
        }

        estudiante.removeCurso(curso);
        return estudianteRepository.save(estudiante);
    }

    public List<Curso> obtenerCursosDeEstudiante(Long estudianteId) {
        Estudiante estudiante = findByIdOrThrow(estudianteId);
        return estudiante.getCursos().stream().toList();
    }
}