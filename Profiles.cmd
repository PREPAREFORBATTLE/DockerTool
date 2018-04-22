set commandline=%0
rem Remove filename to get path
set commandline=%commandline:\RunMSI.cmd=%
rem Remove surrounding quotes
for /f "useback tokens=*" %%a in ('%commandline%') do set commandline=%%~a
rem Only set current directory if not UNC path
if not "%commandline:~0,2%"=="\\" chdir /D %commandline%


PowerShell.exe -Command "& '%~dpn0.ps1'" WintimeWeb
