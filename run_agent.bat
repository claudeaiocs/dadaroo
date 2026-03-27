@echo off
set PATH=C:\flutter\bin;%PATH%
cd /d C:\source\dadaroo
claude --dangerously-skip-permissions -p "$(type build_prompt.txt)"
