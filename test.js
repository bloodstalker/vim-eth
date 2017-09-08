
var Web3 = require('./node_modules/web3')
var web3 = new Web3()
var fs = require("fs")

web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'))

var base = "0xc6833b8af47eccfb6372bd73b825e39d1ec26fbc"
var base1 = "0x08ebf4b32debadd78365f2c1a1187f836a306cc1"

web3.eth.personal.getAccounts().then(function (c) {
  console.log(c);
});

web3.eth.getBalance(base).then(balance => console.log(balance));
web3.eth.getBalance(base1).then(balance => console.log(balance));

var code = fs.readFileSync("./store.bin/SimpleStorage.bin")
var abi = JSON.parse(fs.readFileSync("./store.bin/SimpleStorage.abi"))

var sol_testcontract = new web3.eth.Contract(abi)

var send_opt = {from:base, gas : 4000000}

function test1(c) {
  c.mehtods.send(1, base1)
}

function test(con) {
  sol_testcontract.deploy({data:code, arguments:[base, 1000]}).send(send_opt).then(
    contract => {
      console.log('test contract mined: ' + contract.options.address)
      con(contract)
    }
  )
}

test(test1)
web3.eth.getBalance(base).then(balance => console.log(balance));
web3.eth.getBalance(base1).then(balance => console.log(balance));
