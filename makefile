SOLC?=solc
NODE?=node
NPM?=npm
PKG_MAN?=dnf
TEST_SERVER?=testrpc
NODEJS_TEST?=test.js
EXTRA_BIN_FLAGS?=
EXTRA_ABI_FLAGS?=

CONTRACTS=$(wildcard *.sol)
BIN_DIRS=$(wildcard *.bin)
BIN_FLAGS= --bin --overwrite
ABI_FLAGS= --abi --overwrite

BIN_FLAGS+=$(EXTRA_BIN_FLAGS)
ABI_FLAGS+=$(EXTRA_ABI_FLAGS)

.PHONY: all clean run runtestserver requirements

.DEFAULT: all

all: $(patsubst %.sol, %.bin, $(wildcard *.sol)) runtestserver run

%.bin:%.sol
	$(SOLC) $(BIN_FLAGS) -o $@ $<
	$(SOLC) $(ABI_FLAGS) -o $@ $<

run:
	$(NODE) $(NODEJS_TEST)

clean:
	rm -rf *.bin

requirements:
	$(NPM) --version
	if [[ $$? != 0 ]]; then sudo $(PKG_MAN) install npm
	$(NODE)  --version
	if [[ $$? != 0 ]]; then sudo $(PKG_MAN) install nodejs
	# npm is known not to be able to install web3 globally on all systems
	$(NPM) install web3
	$(NPM) install log4js
	# install ethereum-testrpc
	sudo $(NPM) install -g ethereum-testrpc

runtestserver:
	@ps -aux | grep $(TEST_SERVER) | grep -v grep > /dev/null
	@if [[ $$? != 0 ]]; then $(TEST_SERVER); else :; fi

help:
	@echo 'the ide part thats missing for eth dev from vim.'
	@echo '	all: is the default target. builds bin, abi and runs node.'
	@echo '	run: just runs node on test.js.'
	@echo '	runtestserver: runs your test server. the default is testrpc.'
	@echo '	requirements:  installs the requiremnts.'
	@echo '	clean: remove the bin and abi folder.'
	@echo '	if you are not running an ancient shell, tab will give you the macros that you can change.'
