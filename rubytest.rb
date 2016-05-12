#!/usr/bin/env ruby

require 'ffi'
require 'json'

module LibPP
  extend FFI::Library
  ffi_lib './pp.so'
  attach_function :ProcessInRuby, [:string], :pointer
  attach_function :free, [:pointer], :void
end


begin
  opts ={}
  opts[:file] = "/Users/pagem/Documents/workspace/pileup-processor/test.pileup"
  opts[:ignore_reference_n] = true
  opts[:min_depth] = 6
  opts[:min_non_ref_count] = 3

  puts "RUBY: " + opts.to_json

  out_pointer = LibPP.ProcessInRuby(opts.to_json)
  puts out_pointer.read_string

ensure
  LibPP.free(out_pointer) if out_pointer

end