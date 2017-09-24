
var fs = require("fs");
var http = require("http").createServer();
var Web3 = require("web3");
var web3 = new Web3();
var ipfsPI = require("ipfs-api")

var ipfs = ipfsAPI(host, "5001", {protocol: "http"});

web3.setProvider(new web3.providers.HttpProvider("http:\\" + host + ":8445"));

var bse = wen3.eth.coinbase;

var send_opt = {from:base, gas: 4000000};
