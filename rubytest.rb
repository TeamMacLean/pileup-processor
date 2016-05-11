#!/usr/bin/env ruby

require 'ffi'
require 'json'

module LibPP
  extend FFI::Library
  ffi_lib './pp.so'
  attach_function :ProcessInRuby, [:string], :string
end

opts ={}
opts[:file] = "/Users/pagem/Desktop/high_gpc_align_paired_samtools.pileup"
opts[:ignore_reference_n] = true
opts[:min_depth] = 6
opts[:min_non_ref_count] = 3


puts LibPP.ProcessInRuby(opts.to_json)