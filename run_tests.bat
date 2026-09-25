@echo off
cd /d C:\Users\usuario\Documents\Default Project
start /B mvn spring-boot:run -q
timeout /t 15
echo === POST crear ===
curl.exe -s -X POST http://localhost:8080/api/usuarios -H "Content-Type: application/json" -d "{\"username\":\"testuser\",\"password\":\"123456\"}"
echo.
echo === GET listar ===
curl.exe -s http://localhost:8080/api/usuarios
echo.
echo === GET by ID ===
curl.exe -s http://localhost:8080/api/usuarios/1
echo.
echo === PUT actualizar ===
curl.exe -s -X PUT http://localhost:8080/api/usuarios/1 -H "Content-Type: application/json" -d "{\"username\":\"testuser2\",\"password\":\"123456\"}"
echo.
echo === DELETE ===
curl.exe -s -X DELETE http://localhost:8080/api/usuarios/1
echo.
echo Tests completados
pause