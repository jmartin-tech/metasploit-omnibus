.DEFAULT_GOAL := all

.PHONY: all
all:
	# install omnibus' dependencies
	bundle config set --local deployment false
	bundle config set --local path 'vendor/bundle'
	bundle _2.2.33_ install
	bundle _2.2.33_ binstubs --all
	git diff

	# build the metasploit-framework package
	ruby bin/omnibus build metasploit-framework

.PHONY: clean
clean:
	bin/omnibus clean metasploit-framework
