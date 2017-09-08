SOLC?=solc
NODE?=node
NPM?=npm
PKG_MAN?=dnf
TEST_SERVER?=testrpc
NODEJS_TEST?=test.js
CONTRACTS=$(wildcard *.sol)
BIN_DIRS=$(wildcard *.bin)
BIN_FLAGS= --bin
ABI_FLAGS= --abi

.PHONY: all, clean, run

.DEFAULT: all

all: $(patsubst %.sol, %.bin, $(wildcard *.sol)) run

%.bin:%.sol
	if [[ -d "$(BIN_DIRS)" ]]; then rm -rf $(BIN_DIRS); fi
	$(SOLC) $(BIN_FLAGS) -o $@ $<
	$(SOLC) $(ABI_FLAGS) -o $@ $<

run:
	$(NODE) $(NODEJS_TEST)

clean:
	if [[ -d "$(BIN_DIRS)" ]]; then rm -rf $(BIN_DIRS); fi

requirements:
	$(NPM) --version
	if [[ $? != 0 ]]; then sudo $(PKG_MAN) install npm
	$(NODE)  --version
	if [[ $? != 0 ]]; then sudo $(PKG_MAN) install nodejs
	# npm is known not to be able to install web3 globally on all systems
	$(NPM) install web3
	# install ethereum-testrpc
	sudo $(NPM) install -g ethereum-testrpc

runtestserver:
	$(TEST_SERVER)

help:
	@echo 'the ide part thats missing for eth dev from vim.'
	@echo '	all: is the default target. builds bin, abi and runs node.'
	@echo '	run: just runs node on test.js.'
	@echo '	runtestserver: runs your test server. the default is testrpc.'
	@echo '	clean: remove the bin and abi folder.'
	@echo '	if you are not running an ancient shell, tab will give you the macros that you can change.'
