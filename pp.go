//# encoding: utf-8
//
//require 'yaml'
//require 'bio-samtools'
//require 'bio-gngm'
//
//vars_hash = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
//
//File.foreach(ARGV[0]) do |line|
//pileup = Bio::DB::Pileup.new(line)
//if pileup.is_snp?(:ignore_reference_n => true, :min_depth => 6, :min_non_ref_count => 3) and pileup.consensus != pileup.ref_base
//vars_hash[pileup.ref_name][pileup.pos] = pileup.coverage
//# puts "#{pileup.ref_name}\t#{pileup.pos}\t#{pileup.consensus}\t#{basehash}\n"
//end
//end
//
//File.open("normal_pileup_var_pos.yml", 'w') do |file|
//file.write vars_hash.to_yaml
//end

package main

import (
	"os"
	"bufio"
	"strings"
	"strconv"
	"encoding/json"
	"io/ioutil"
	"C"
)

func main() {
	checkInputs()
	inputFile := os.Args[1]
	outFile := os.Args[2]
	options := Options{minDepth:6, minNonRefCount:3, ignoreReferenceN:true}
	json := Process(inputFile, options)
	writeJson(string(json), outFile);
}

func Process(path string, options Options) string {
	keepers := readFile(path, options)
	strB, err := json.MarshalIndent(keepers, "", "    ")
	if (err != nil) {
		panic(err)
	}
	return string(strB)
}

//export ProcessInRuby
func ProcessInRuby(intOpts *C.char) *C.char {

	type RubyOptions struct {
		File             string `json:"file"`
		IgnoreReferenceN bool `json:"ignore_reference_n"`
		MinDepth         int `json:"min_depth"`
		MinNonRefCount   int `json:"min_non_ref_count"`
	}

	optString := C.GoString(intOpts)
	ro := RubyOptions{}
	json.Unmarshal([]byte(optString), &ro)

	println(optString)

	options := Options{ro.MinDepth, ro.MinNonRefCount, ro.IgnoreReferenceN}

	out := string(Process(ro.File, options))
	return C.CString(out)

}

type Options struct {
	minDepth         int
	minNonRefCount   int
	ignoreReferenceN bool
}


//seq1 272 T 24  ,.$.....,,.,.,...,,,.,..^+. <<<+;<<<<<<<<<<<=<;<;7<&
type Pileup struct {
	RefName   string `json:"refName"`
	Pos       int `json:"pos"`
	RefBase   string `json:"refBase"`
	Coverage  int `json:"coverage"`
	ReadBases string `json:"readBases"`
	ReadQuals string `json:"readQuals"`
}

func (r Pileup) nonRefCount() int {
	//def non_ref_count
	//if @non_ref_count.nil?
	//@non_ref_count = @read_bases.count("ATGCatgc").to_f
	//end
	//@non_ref_count
	//end
	return strings.Count(r.ReadBases, "A") + strings.Count(r.ReadBases, "T") + strings.Count(r.ReadBases, "G") + strings.Count(r.ReadBases, "C") + strings.Count(r.ReadBases, "a") + strings.Count(r.ReadBases, "t") + strings.Count(r.ReadBases, "g") + strings.Count(r.ReadBases, "c")
}

func (r Pileup) isSNP(options Options) bool {
	//def is_snp?(opts)
	//return false if self.ref_base == '*'
	//#return false unless is_ct
	//return false if opts[:ignore_reference_n] and self.ref_base == "N" or self.ref_base == "n"
	//return true if self.coverage >= opts[:min_depth] and self.non_ref_count >= opts[:min_non_ref_count]
	//false
	//end

	if (r.ReadBases == "*") {
		return false
	}
	if (options.ignoreReferenceN) {
		if (r.RefBase == "N" || r.RefBase == "n") {
			return false
		}
	}
	if (r.Coverage >= options.minDepth && r.nonRefCount() >= options.minNonRefCount) {
		return true
	}
	return false

}

func checkInputs() {
	if (len(os.Args) < 3) {
		panic("supply input.pileup and output.json file")
	}
}

func readFile(in string, options Options) []Pileup {

	if _, err := os.Stat(in); os.IsNotExist(err) {
		// path/to/whatever does not exist
		panic(in + " DOES NOT EXIST")
	}

	keepers := make([]Pileup, 0)
	inFile, _ := os.Open(in)
	defer inFile.Close()
	scanner := bufio.NewScanner(inFile)
	scanner.Split(bufio.ScanLines)

	for scanner.Scan() {
		text := scanner.Text()
		s := strings.Split(text, "\t");

		if (len(s) != 6) {
			panic("there were " + strconv.Itoa(len(s)) + " chunks instead of 6")
		}

		coverageInt, err := strconv.Atoi(s[3])
		if (err != nil) {
			panic(err)
		}

		posInt, err := strconv.Atoi(s[1])
		if (err != nil) {
			panic(err)
		}

		p := Pileup{s[0], posInt, s[2], coverageInt, s[4], s[5]}

		if (p.isSNP(options)) {
			keepers = append(keepers, p)
		}

	}
	return keepers
}

func writeJson(json string, outfile string) {
	err := ioutil.WriteFile(outfile, []byte(json), 0644)
	if (err != nil) {
		panic(err)
	}
}