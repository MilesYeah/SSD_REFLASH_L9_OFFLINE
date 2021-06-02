

pandoc.exe .\release_note.md -f markdown -t html -o .\release_note.html

$commit_msg=(cat .\release_note.md | findstr /i "version.20[0-9]\." | select -first 1)

git add .
git commit -m "$commit_msg"

git push origin master

