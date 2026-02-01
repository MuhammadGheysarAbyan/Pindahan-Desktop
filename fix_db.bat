@echo off
echo Compiling ForceFixDB...
javac -cp "C:\Penyimpanan Utama\Unduhan\mysql-connector-j-8.0.33.jar" "c:\Penyimpanan Utama\Documents\NetbeansProject\DistroZone\src\ForceFixDB.java"
if %errorlevel% neq 0 (
    echo Compilation failed!
    exit /b %errorlevel%
)
echo Running ForceFixDB...
java -cp "c:\Penyimpanan Utama\Documents\NetbeansProject\DistroZone\src;C:\Penyimpanan Utama\Unduhan\mysql-connector-j-8.0.33.jar" ForceFixDB

