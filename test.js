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

var base = "0x5a7d2aabc0e43ac6c96444400c51dbc538b0f508";
var base1 = "0x266148e2b4076e39f1670de27a9a00706cf1380d";

web3.eth.personal.getAccounts().then(function (c) {
  console.log(c);
});

web3.eth.getBalance(base).then(balance => console.log(balance));
web3.eth.getBalance(base1).then(balance => console.log(balance));

var code = fs.readFileSync("./store.bin/SimpleStorage.bin");
var abi = JSON.parse(fs.readFileSync("./store.bin/SimpleStorage.abi"));

var codesalsa208 = fs.readFileSync("./salsa.bin/Salsa8.bin");
var abisalsa208 = JSON.parse(fs.readFileSync("./salsa.bin/Salsa8.abi"));

var sol_testcontract = new web3.eth.Contract(abi);
var salsa_testcontract = new web3.eth.Contract(abisalsa208);

var send_opt = {from:base, gas : 4000000}

function salsatest(c) {
  var fm7 = "61707865";
  var fm6 = "04030201";
  var fm5 = "08070605";
  var fm4 = "0c0b0a09";
  var fm3 = "100f0e0d";
  var fm2 = "3320646e";
  var fm1 = "01040103";
  var fm0 = "06020905";

  var sm7 = "00000007";
  var sm6 = "00000000";
  var sm5 = "79622d32";
  var sm4 = "14131211";
  var sm3 = "18171615";
  var sm2 = "1c1b1a19";
  var sm1 = "201f1e1d";
  var sm0 = "6b206574";

  var _first_str = fm7.concat(fm6, fm5, fm4, fm3, fm2, fm1, fm0);
  var _second_str = sm7.concat(sm6, sm5, sm4, sm3, sm2, sm1, sm0);
  logger.info(_first_str);
  logger.info(_second_str);

  c.methods.salsa20_20(_first_str, _second_str).send(send_opt).then(res => logger.info(res));
}

function test1(c) {
  var input = 123456789;
  c.methods.set(input).send(send_opt).then(() => c.methods.get().call().then(res => logger.info(res)));
}

function test(con, test_con) {
  test_con.deploy({data:code, arguments:[base, 987654321]}).send(send_opt).then(
    contract => {
      logger.info('test contract mined.');
      con(contract)
      logger.info("test contract finished.")
    }
  )
}

function deploysalsa(con) {
  salsa_testcontract.deploy({data:codesalsa208}).send(send_opt).then(
    contract => {
      logger.info('salsa test contract mined.');
      con(contract)
      logger.info("salsa test contract finished.")
    }
  )
}

function salsa20_8(con, con_code) {
  var salsainstance = con.new({data:con_code, from:base, gas:1000000});
  var salsadeployed = con.at(base);
}

//test(test1, sol_testcontract);
deploysalsa(salsatest);
