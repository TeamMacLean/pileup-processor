#!/usr/bin/env ruby

require 'ffi'
require 'json'

module LibPP
  extend FFI::Library
  ffi_lib './pp.so'
  attach_function :ProcessInRuby, [:string], :string
  attach_function :free, [:pointer], :void
end


opts ={}
opts[:file] = "/Users/pagem/Desktop/high_gpc_align_paired_samtools.pileup"
# opts[:file] = "/Users/pagem/Documents/workspace/pileup-processor/test.pileup"
opts[:out] = "/Users/pagem/Documents/workspace/pileup-processor/test.txt"
opts[:ignore_reference_n] = true
opts[:min_depth] = 6
opts[:min_non_ref_count] = 3

puts "RUBY SENT: " + opts.to_json

error = LibPP.ProcessInRuby(opts.to_json)

unless error == nil
  puts error
end