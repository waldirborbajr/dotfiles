# find . -iname target -type d -exec rm -r '{}' \;
find $HOME -name '*.bkp' -type f | xargs rm -r
