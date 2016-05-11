#!/usr/bin/env ruby

require 'ffi'

module LibPP
  extend FFI::Library
  ffi_lib './pp.so'
  attach_function :ProcessInRuby, [:string], :string
end

puts LibPP.ProcessInRuby("/Users/pagem/Desktop/high_gpc_align_paired_samtools.pileup")