
Write-Host 'Plz check any update for FW updating tool, and did you update the version defined in SCRIPT?'
$null = [Console]::ReadKey('?')


# Write-Host 'Press Any Key to continue following auto-matic actions!' -NoNewline
Write-Host 'Press Any Key to continue following auto-matic actions!'
$null = [Console]::ReadKey('?')

pandoc.exe .\release_note.md -f markdown -t html -o .\release_note.html

$commit_msg=(cat .\release_note.md | findstr /i "version.20[0-9]\." | select -first 1)

git add .
git commit -m "$commit_msg"

git push origin master

