package com.example.demo.service;

import com.example.demo.entity.Curso;
import com.example.demo.repository.CursoRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CursoService {

    @Autowired
    private CursoRepository cursoRepository;

    public List<Curso> findAll() {
        return cursoRepository.findAll();
    }

    public Optional<Curso> findById(Long id) {
        return cursoRepository.findById(id);
    }

    public Curso findByIdOrThrow(Long id) {
        return cursoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Curso no encontrado con ID: " + id));
    }

    public Curso save(@Valid Curso curso) {
        return cursoRepository.save(curso);
    }

    public Curso update(Long id, @Valid Curso cursoDetails) {
        Curso curso = findByIdOrThrow(id);
        curso.setNombre(cursoDetails.getNombre());
        curso.setCreditos(cursoDetails.getCreditos());
        return cursoRepository.save(curso);
    }

    public void deleteById(Long id) {
        if (!cursoRepository.existsById(id)) {
            throw new EntityNotFoundException("Curso no encontrado con ID: " + id);
        }
        cursoRepository.deleteById(id);
    }
}