@echo off

setlocal EnableDelayedExpansion
for /f "tokens=*" %%i in ('findstr \"name\" info.json') do (
    set "Line=%%i"
    set "Line=!Line:* "=!"
)
set "Modname=!Line:",=!"

for /f "tokens=*" %%i in ('findstr \"version\" info.json') do (
    set "Line=%%i"
    set "Line=!Line:* "=!"
)
set "Version=!Line:",=!"
echo Preparing to publish %Modname% Version %Version%...

echo Copying files to %Modname%_%Version%...
cd ..
xcopy /S /I /E %Modname% %Modname%_%Version% /EXCLUDE:%Modname%\publish_exclude.txt

echo Compressing %Modname%_%Version%.zip...
7z a %Modname%_%Version%.zip %Modname%_%Version%

echo Cleaning up temporary files...
rd /S /Q %Modname%_%Version%

echo Finished publishing %Modname% Version %Version%.
