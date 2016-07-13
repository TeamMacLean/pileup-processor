# encoding: utf-8

require 'bio-samtools'
require 'bio-gngm'

outfile = File.open('orig_out.txt', 'w')
File.foreach(ARGV[0]) do |line|
  pileup = Bio::DB::Pileup.new(line)
  if pileup.is_snp?(:ignore_reference_n => true, :min_depth => 6, :min_non_ref_count => 3)
    outfile.puts line
  end
end
outfile.close
