@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo   ANALIZADOR SONARQUBE PARA FLUTTER - ARO MOVIES APP
echo ============================================================
echo.

echo [1/5] Respaldando configuracion original...
if exist analysis_options.yaml (
    copy analysis_options.yaml analysis_options.yaml.bak >nul 2>&1
    echo     Configuracion respaldada exitosamente
) else (
    echo     ADVERTENCIA: No se encontro analysis_options.yaml
)

echo [2/5] Aplicando configuracion optimizada para SonarQube...
if exist analysis_options.yaml.sonar (
    copy analysis_options.yaml.sonar analysis_options.yaml >nul 2>&1
    echo     Configuracion aplicada exitosamente
) else (
    echo     ERROR: No se encontro analysis_options.yaml.sonar
    goto :cleanup
)

echo [3/5] Generando reporte de analisis manual...
if not exist "build\reports" mkdir "build\reports"
echo     Ejecutando flutter analyze...
call flutter analyze --no-fatal-warnings --no-fatal-infos > build\reports\analysis-results.txt 2>&1
if %ERRORLEVEL% EQU 0 (
    echo     Reporte generado exitosamente
) else (
    echo     Advertencia: flutter analyze termino con codigo %ERRORLEVEL%
)

echo [4/5] Ejecutando SonarQube Scanner...
echo     Iniciando SonarQube Scanner...
call "C:\SonarQube\bin\sonar-scanner.bat"
if %ERRORLEVEL% EQU 0 (
    echo     SonarQube ejecutado exitosamente
) else (
    echo     Advertencia: SonarQube termino con codigo %ERRORLEVEL%
)

:cleanup
echo [5/5] Restaurando configuracion original...
if exist analysis_options.yaml.bak (
    copy analysis_options.yaml.bak analysis_options.yaml >nul 2>&1
    del analysis_options.yaml.bak >nul 2>&1
    echo     Configuracion original restaurada
) else (
    echo     No hay configuracion original para restaurar
)

echo.
echo ============================================================
echo   ANALISIS COMPLETADO
echo ============================================================
echo   Dashboard: http://localhost:9000/dashboard?id=aro_movies_app
echo ============================================================
echo.
echo Presiona cualquier tecla para continuar...
pause >nul


