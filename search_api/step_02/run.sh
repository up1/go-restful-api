CURDIR=`pwd`
OLDGOPATH=$GOPATH
export GOPATH=$CURDIR
# go get gopkg.in/mgo.v2
# go get gopkg.in/tomb.v2
gofmt -w src/
go test -v -cover -coverprofile=coverage.out  ./...
go install main
export GOPATH=$OLDGOPATH
echo 'finished'
