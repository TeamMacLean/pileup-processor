### Comparison of file processing times

* This is an extension of [previous comparison](https://github.com/shyamrallapalli/mutations_hts_noref/tree/3eef020c2e8f84cc67b2cda981f14835eed904aa/004_miscellaneous/reading_pileup_file_compare)

* Pileup file is downloaded from the link included in above report
		
		
##### testing with orig.rb script

```shell

⇒  for i in {1..5}; do sudo purge && time ruby orig.rb 10m_lines.pileup ; done
ruby orig.rb 10m_lines.pileup  108.51s user 2.21s system 97% cpu 1:53.10 total
ruby orig.rb 10m_lines.pileup  111.71s user 2.12s system 98% cpu 1:56.02 total
ruby orig.rb 10m_lines.pileup  107.33s user 2.02s system 98% cpu 1:51.43 total
ruby orig.rb 10m_lines.pileup  117.09s user 2.27s system 90% cpu 2:11.54 total
ruby orig.rb 10m_lines.pileup  110.74s user 1.95s system 93% cpu 2:00.24 total


```
		
Average time:	min 01:58.5 seconds
		
		
##### testing with process.rb script using string count method

```shell

⇒  for i in {1..5}; do sudo purge && time ruby process.rb 10m_lines.pileup ; done
ruby process.rb 10m_lines.pileup  36.71s user 1.17s system 97% cpu 39.010 total
ruby process.rb 10m_lines.pileup  35.03s user 0.97s system 97% cpu 36.815 total
ruby process.rb 10m_lines.pileup  39.39s user 1.18s system 96% cpu 42.150 total
ruby process.rb 10m_lines.pileup  40.43s user 1.16s system 97% cpu 42.518 total
ruby process.rb 10m_lines.pileup  37.23s user 0.97s system 97% cpu 38.992 total


```
		
Average time:	 39.9 seconds
		
		
##### testing with rubytest.rb script using pp.go to process pileup file

```shell

⇒  for i in {1..5}; do sudo purge && time ruby rubytest.rb ; done
ruby rubytest.rb  9.49s user 3.36s system 77% cpu 16.488 total
ruby rubytest.rb  9.44s user 3.33s system 78% cpu 16.229 total
ruby rubytest.rb  9.47s user 3.33s system 74% cpu 17.084 total
ruby rubytest.rb  9.87s user 3.50s system 75% cpu 17.797 total
ruby rubytest.rb  10.16s user 3.62s system 73% cpu 18.756 total


```
		
Average time:	 17.3 seconds
		

Pileup file processing through pp.go is 2.3 times faster than ruby script and about ~7 times faster than using rubyscript with bio ruby gems.

