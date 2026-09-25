package com.tecsup.aspect;

import com.tecsup.entity.Producto;
import com.tecsup.service.AuditoriaService;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Aspect
@Component
public class AuditoriaAspect {

    @Autowired
    private AuditoriaService auditoriaService;

    // Usuarios y roles
    private final Map<String, String> usuarios = Map.of(
            "Ricardo", "ADMIN",
            "Ana", "USER",
            "Luis", "USER"
    );

    private String obtenerUsuario() {
        String usuario = getHeaderUsuario();
        if (usuario == null) return "ANONIMO";
        String rol = usuarios.get(usuario);
        return (rol != null) ? usuario + " (" + rol + ")" : "DESCONOCIDO";
    }

    private String getHeaderUsuario() {
        try {
            var attrs = org.springframework.web.context.request.RequestContextHolder.getRequestAttributes();
            if (attrs instanceof org.springframework.web.context.request.ServletRequestAttributes servletAttrs) {
                return servletAttrs.getRequest().getHeader("Usuario");
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    private String getHeaderRol() {
        try {
            var attrs = org.springframework.web.context.request.RequestContextHolder.getRequestAttributes();
            if (attrs instanceof org.springframework.web.context.request.ServletRequestAttributes servletAttrs) {
                return servletAttrs.getRequest().getHeader("Rol");
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    private void validarRol(String... rolesPermitidos) {
        String usuario = getHeaderUsuario();
        String rol = getHeaderRol();
        if (usuario == null || rol == null) {
            throw new RuntimeException("Debe enviar headers Usuario y Rol");
        }
        String rolReal = usuarios.get(usuario);
        if (rolReal == null || !rolReal.equals(rol)) {
            throw new RuntimeException("Usuario/Rol no válido");
        }
        boolean permitido = false;
        for (String r : rolesPermitidos) {
            if (r.equals(rol)) { permitido = true; break; }
        }
        if (!permitido) throw new RuntimeException("Acceso denegado: rol " + rol + " no autorizado");
    }

    // ===== AUTORIZACIÓN (@Before) =====
    @Before("execution(* com.tecsup.service.ProductoService.guardar(..))")
    public void validarCrear() { validarRol("ADMIN", "USER"); }

    @Before("execution(* com.tecsup.service.ProductoService.actualizar(..))")
    public void validarActualizar() { validarRol("ADMIN"); }

    @Before("execution(* com.tecsup.service.ProductoService.eliminar(..))")
    public void validarEliminar() { validarRol("ADMIN"); }

    @Before("execution(* com.tecsup.service.ProductoService.listar(..))")
    public void validarListar() { validarRol("ADMIN", "USER"); }

    @AfterReturning("execution(* com.tecsup.service.ProductoService.guardar(..))")
    public void auditarGuardar(JoinPoint joinPoint) {
        auditoriaService.registrar(
                "CREAR",
                joinPoint.getSignature().getName(),
                obtenerUsuario() + " - Se registró un producto: " + obtenerParametros(joinPoint)
        );
    }

    @AfterReturning("execution(* com.tecsup.service.ProductoService.actualizar(..))")
    public void auditarActualizar(JoinPoint joinPoint) {
        Object[] args = joinPoint.getArgs();
        String detalle = obtenerUsuario() + " - Se actualizó producto con ID: " + (args.length > 0 ? args[0].toString() : "desconocido");
        
        auditoriaService.registrar(
                "ACTUALIZAR",
                joinPoint.getSignature().getName(),
                detalle
        );
    }

    @Around("execution(* com.tecsup.service.ProductoService.listar(..))")
    public Object auditarListar(ProceedingJoinPoint joinPoint) throws Throwable {
        Object result = joinPoint.proceed();
        List<Producto> productos = (List<Producto>) result;
        int cantidad = (productos != null) ? productos.size() : 0;

        auditoriaService.registrar(
                "LISTAR",
                joinPoint.getSignature().getName(),
                obtenerUsuario() + " - Se listaron " + cantidad + " registro(s)"
        );
        return result;
    }

    @AfterReturning("execution(* com.tecsup.service.ProductoService.eliminar(..))")
    public void auditarEliminar(JoinPoint joinPoint) {
        Object[] args = joinPoint.getArgs();
        String detalle = obtenerUsuario() + " - Se eliminó producto con ID: " + (args.length > 0 ? args[0].toString() : "desconocido");

        auditoriaService.registrar(
                "ELIMINAR",
                joinPoint.getSignature().getName(),
                detalle
        );
    }

    private String obtenerParametros(JoinPoint joinPoint) {
        Object[] args = joinPoint.getArgs();

        if (args.length == 0) return "sin datos";

        Object obj = args[0];

        if (obj instanceof Producto p) {
            return "nombre=" + p.getNombre() + ", precio=" + p.getPrecio() + ", stock=" + p.getStock();
        }

        return obj.toString();
    }
}