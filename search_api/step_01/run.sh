CURDIR=`pwd`
OLDGOPATH=$GOPATH
export GOPATH=$CURDIR
gofmt -w src/
go install main
export GOPATH=$OLDGOPATH
echo 'finished'
