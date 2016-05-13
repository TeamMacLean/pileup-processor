# encoding: utf-8

require 'yaml'
require 'bio-samtools'
require 'bio-gngm'

vars_hash = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

File.foreach(ARGV[0]) do |line|
  pileup = Bio::DB::Pileup.new(line)
  if pileup.is_snp?(:ignore_reference_n => true, :min_depth => 6, :min_non_ref_count => 3) and pileup.consensus != pileup.ref_base
    vars_hash[pileup.ref_name][pileup.pos] = pileup.coverage
    # puts "#{pileup.ref_name}\t#{pileup.pos}\t#{pileup.consensus}\t#{basehash}\n"
  end
end

File.open("normal_pileup_var_pos.yml", 'w') do |file|
  file.write vars_hash.to_yaml
end