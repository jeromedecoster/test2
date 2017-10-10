tmp=/tmp/dots
lib=/usr/local/lib/dots2

if [[ `git rev-parse --is-inside-work-tree 2>/dev/null` == 'true' ]]; then
    echo offline install
elif [[ `pwd` == '/tmp/dots' ]]; then
    echo /tmp/dots install
else
    echo online install
    mkdir -p /tmp/dots
    cd /tmp/dots
    curl -sSL https://github.com/jeromedecoster/test2/archive/master.tar.gz | tar zx --strip 1
    #bash ./install.sh
    cp -R $tmp $lib
fi