package com.example.demo.service;

import com.example.demo.entity.Perfil;
import com.example.demo.entity.Usuario;
import com.example.demo.repository.PerfilRepository;
import com.example.demo.repository.UsuarioRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class PerfilService {

    @Autowired
    private PerfilRepository perfilRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    public List<Perfil> findAll() {
        return perfilRepository.findAll();
    }

    public Optional<Perfil> findById(Long id) {
        return perfilRepository.findById(id);
    }

    public Perfil findByIdOrThrow(Long id) {
        return perfilRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Perfil no encontrado con ID: " + id));
    }

    public Perfil findByUsuarioId(Long usuarioId) {
        return perfilRepository.findByUsuarioId(usuarioId);
    }

    public Perfil save(@Valid Perfil perfil) {
        return perfilRepository.save(perfil);
    }

    public Perfil saveForUsuario(Long usuarioId, @Valid Perfil perfil) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new EntityNotFoundException("Usuario no encontrado con ID: " + usuarioId));
        if (usuario.getPerfil() != null) {
            throw new IllegalArgumentException("El usuario ya tiene un perfil asociado");
        }
        perfil.setUsuario(usuario);
        return perfilRepository.save(perfil);
    }

    public Perfil update(Long id, @Valid Perfil perfilDetails) {
        Perfil perfil = findByIdOrThrow(id);
        perfil.setNombreCompleto(perfilDetails.getNombreCompleto());
        perfil.setDireccion(perfilDetails.getDireccion());
        perfil.setTelefono(perfilDetails.getTelefono());
        return perfilRepository.save(perfil);
    }

    public void deleteById(Long id) {
        if (!perfilRepository.existsById(id)) {
            throw new EntityNotFoundException("Perfil no encontrado con ID: " + id);
        }
        perfilRepository.deleteById(id);
    }

    public boolean existsById(Long id) {
        return perfilRepository.existsById(id);
    }
}