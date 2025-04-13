@echo off
set REPO_URL=https://github.com/adhi-jp/.gitalias.git
set TARGET_DIR=%USERPROFILE%\.config\git\.gitalias

REM Prompt user to start installation
choice /m "Do you want to start the installation?"
if errorlevel 2 (
    echo Installation cancelled.
    exit /b 0
)

REM Create the parent directory of TARGET_DIR
mkdir "%USERPROFILE%\.config\git"

REM Check if git is installed
where git >nul 2>&1
if errorlevel 1 (
    echo Error: git is not installed.
    exit /b 1
)

REM If the repository already exists, update it; otherwise, clone it
if exist "%TARGET_DIR%\.git" (
    echo Updating the existing repository...
    pushd "%TARGET_DIR%"
    git pull
    popd
) else (
    echo Cloning the repository...
    git clone %REPO_URL% "%TARGET_DIR%"
)

REM Create variable UNIX_GITCONFIG and convert to Unix path format
set UNIX_GITCONFIG=%TARGET_DIR%\.gitconfig
set UNIX_GITCONFIG=%UNIX_GITCONFIG:\=/%

REM Add include.path to git global config if not already set
git config --global --get-all include.path | findstr /C:"%UNIX_GITCONFIG%" >nul 2>&1
if errorlevel 1 (
    echo Adding include.path to git global config...
    git config --global --add include.path "%UNIX_GITCONFIG%"
)

echo Installation completed successfully.
REM Wait for user input before exiting
pause
