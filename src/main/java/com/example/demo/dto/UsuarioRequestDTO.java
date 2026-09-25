package com.example.demo.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class UsuarioRequestDTO {

    @NotBlank(message = "El username es obligatorio")
    @Size(min = 3, max = 50, message = "El username debe tener entre 3 y 50 caracteres")
    private String username;

    @NotBlank(message = "La contraseña es obligatoria")
    @Size(min = 6, message = "La contraseña debe tener al menos 6 caracteres")
    private String password;

    private PerfilRequestDTO perfil;

    public UsuarioRequestDTO() {}

    public UsuarioRequestDTO(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public PerfilRequestDTO getPerfil() {
        return perfil;
    }

    public void setPerfil(PerfilRequestDTO perfil) {
        this.perfil = perfil;
    }

    public static class PerfilRequestDTO {
        @NotBlank(message = "El nombre completo es obligatorio")
        @Size(max = 100, message = "El nombre completo no puede exceder 100 caracteres")
        private String nombreCompleto;

        @Size(max = 200, message = "La dirección no puede exceder 200 caracteres")
        private String direccion;

        @Size(max = 20, message = "El teléfono no puede exceder 20 caracteres")
        private String telefono;

        public PerfilRequestDTO() {}

        public String getNombreCompleto() {
            return nombreCompleto;
        }

        public void setNombreCompleto(String nombreCompleto) {
            this.nombreCompleto = nombreCompleto;
        }

        public String getDireccion() {
            return direccion;
        }

        public void setDireccion(String direccion) {
            this.direccion = direccion;
        }

        public String getTelefono() {
            return telefono;
        }

        public void setTelefono(String telefono) {
            this.telefono = telefono;
        }
    }
}