go build -buildmode=c-shared -o pp.so pp.go

go build -buildmode=c-shared -o pp.so pp.go &&./rubytest.rb 