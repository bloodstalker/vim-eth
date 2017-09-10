var log4js = require('./node_modules/log4js')
var Web3 = require('./node_modules/web3')
var fs = require("fs")

var logger = log4js.getLogger();
logger.level = 'info'

if (typeof web3 != 'undefined') {
  web3 = new Web3.currentProvider();
} else {
  web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
}

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
  c.methods.set(123456789)
  var value = c.methods.get()
  logger.info(value.eth_getBalance)
  logger.info(web3.eth.gasPrice);
  logger.info(web3.eth.getBalance(base));
  logger.info(web3.eth.getBalance(base1));
  //logger.info(value)
  c.methods.send(base1, 1)
  logger.info('sent 1 ether')
  //logger.info(c.methods.getBalance(base))
  //logger.info(c.methods.getBalance(base1))
}

function test(con) {
  sol_testcontract.deploy({data:code, arguments:[base, 1000]}).send(send_opt).then(
    contract => {
      logger.info('test contract mined.');
      con(contract)
    }
  )
}

test(test1)
