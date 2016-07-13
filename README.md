### A GO lib to read a pileup file and select variant positions and write out a json

##### how to run / compile

```shell

go build -buildmode=c-shared -o pp.so pp.go

```

#### implementaion in ruby

A test ruby script `rubytest.rb` is provided for example implementation and testing

```shell

go build -buildmode=c-shared -o pp.so pp.go &&./rubytest.rb

```
