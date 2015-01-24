@echo off
set var=%~dp0..%/AzCoreLib/AzWindowCore/azCore.exe
start "" "%var%" "%cd%/main.lua"