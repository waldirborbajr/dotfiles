cp -r ~/.zshrc .
cp -r ~/.config/nvim .

cd nvim
rm -rf autoload plugged undodir

git add -A . && git commit -m "chore: updated" && git push origin HEAD
