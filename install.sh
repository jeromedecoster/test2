
if [[ `git rev-parse --is-inside-work-tree 2>/dev/null` == 'true' ]]; then
    echo offline install
else
    echo online install
fi