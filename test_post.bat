@echo off
curl.exe -v -X POST http://localhost:8080/api/productos -H "Content-Type: application/json" -H "Usuario: Ricardo" -H "Rol: ADMIN" -d @test.json
pause