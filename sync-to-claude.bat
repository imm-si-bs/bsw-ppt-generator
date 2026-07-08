@echo off
echo Syncing agent and skill files to Claude Code...

:: Create destination directories if they don't exist
if not exist "%USERPROFILE%\.claude\agents" mkdir "%USERPROFILE%\.claude\agents"
if not exist "%USERPROFILE%\.claude\skills\siemens-ppt-gen" mkdir "%USERPROFILE%\.claude\skills\siemens-ppt-gen"

:: Agents
copy /Y "agents\lst-meeting-builder.md" "%USERPROFILE%\.claude\agents\lst-meeting-builder.md"
copy /Y "agents\siemens-ppt-builder.md" "%USERPROFILE%\.claude\agents\siemens-ppt-builder.md"

:: Skills
copy /Y "skills\siemens-ppt-gen\SKILL.md" "%USERPROFILE%\.claude\skills\siemens-ppt-gen\SKILL.md"
copy /Y "skills\siemens-ppt-gen\BRANDING.md" "%USERPROFILE%\.claude\skills\siemens-ppt-gen\BRANDING.md"

echo Done. Claude Code will now use the updated files.
pause
