@echo off
cmd /c flutter test --coverage

REM Generar reporte HTML con genhtml (llamado vía perl)
cmd /c perl C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml coverage\lcov.info --output-directory coverage\html

REM Abrir reporte
cmd /c start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" "%CD%\coverage\html\index.html"
