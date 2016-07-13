# encoding: utf-8

# require 'yaml'
# require 'bio-samtools'
# require 'bio-gngm'

def is_snp(p, options)
  return false if p[4] == '*'
  return false if options[:ignore_reference_n] and p[2] == "N" or p[2] == "n"
  return true if p[3].to_i >= options[:min_depth] and non_ref_count(p[4]) >= options[:min_non_ref_count]
  false
end

def count(str)
  counter = 0
  str.each_char do |c|
    if c=="A" || c=="T" || c=="G" || c="C" || c=="a" || c=="t" || c=="g" || c="c"
      counter+=1
    end
  end
  counter
end

def non_ref_count(str)
  # str.count("ATGCatgc")
  count(str)
end


vars_hash = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }

File.foreach(ARGV[0]) do |line|

  split_line = line.split("\t")

  opts ={}
  opts[:ignore_reference_n] = true
  opts[:min_depth] = 6
  opts[:min_non_ref_count] = 3


  if is_snp(split_line, opts)
    vars_hash[split_line[0]][split_line[1].to_i] = split_line
  end
end

