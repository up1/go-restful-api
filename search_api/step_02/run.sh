CURDIR=`pwd`
OLDGOPATH=$GOPATH
export GOPATH=$CURDIR
gofmt -w src/
go test -v -cover -coverprofile=coverage.out  ./...
go install main
export GOPATH=$OLDGOPATH
echo 'finished'
