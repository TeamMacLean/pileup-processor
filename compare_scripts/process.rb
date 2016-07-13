# encoding: utf-8

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
  str.count("ATGCatgc")
  # count(str)
end

opts ={}
opts[:ignore_reference_n] = true
opts[:min_depth] = 6
opts[:min_non_ref_count] = 3

outfile = File.open('str_count_out.txt', 'w')
# outfile = File.open('char_count_out.txt', 'w')
File.foreach(ARGV[0]) do |line|
  split_line = line.split("\t")
  if is_snp(split_line, opts)
    outfile.puts line
  end
end
outfile.close
