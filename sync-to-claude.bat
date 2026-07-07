@echo off
echo Syncing agent and skill files to Claude Code...
copy /Y "agents\bsw-ppt-builder.md" "%USERPROFILE%\.claude\agents\bsw-ppt-builder.md"
copy /Y "skills\bsw-ppt\SKILL.md" "%USERPROFILE%\.claude\skills\bsw-ppt\SKILL.md"
copy /Y "skills\bsw-ppt\BSWBRANDING.md" "%USERPROFILE%\.claude\skills\bsw-ppt\BSWBRANDING.md"
echo Done. Claude Code will now use the updated files.
pause
