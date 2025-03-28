@echo off
set USERNAME=osama32895
set REPO=key-storage
set FILE_PATH=keys.txt
set BRANCH=main
set GITHUB_TOKEN=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

:: Step 1: Get file content from GitHub API
curl -H "Authorization: token %GITHUB_TOKEN%" ^
  -H "Accept: application/vnd.github.v3.raw" ^
  -o original-keys.txt ^
  https://api.github.com/repos/%USERNAME%/%REPO%/contents/%FILE_PATH%
timeout /t 1
:: Step 2: Remove the first line
powershell -Command "(Get-Content original-keys.txt | Select-Object -Skip 1) | Set-Content modified-keys.txt"
timeout /t 1
:: Step 3: Convert modified file to Base64
powershell -Command "[Convert]::ToBase64String([System.IO.File]::ReadAllBytes('modified-keys.txt'))" > base64-content.txt
set /p BASE64_CONTENT=<base64-content.txt
timeout /t 1
:: Step 4: Get latest SHA for the file
for /f "delims=" %%a in ('curl -s -H "Authorization: token %GITHUB_TOKEN%" ^
  https://api.github.com/repos/%USERNAME%/%REPO%/contents/%FILE_PATH% ^
  ^| jq -r .sha') do set SHA=%%a
timeout /t 1
:: Step 5: Update file on GitHub
curl -X PUT ^
  -H "Authorization: token %GITHUB_TOKEN%" ^
  -H "Accept: application/vnd.github.v3+json" ^
  -d "{\"message\":\"Removed first line from keys.txt\",\"sha\":\"%SHA%\",\"content\":\"%BASE64_CONTENT%\",\"branch\":\"%BRANCH%\"}" ^
  https://api.github.com/repos/%USERNAME%/%REPO%/contents/%FILE_PATH%
:: Step 6: Clean up temporary files
del original-keys.txt
del modified-keys.txt
del base64-content.txt
