var artifactor = require("truffle-artifactor");
var jj = require("./Transcript.json");

var contract_data = {
  abi: jj.abi,                   
};

artifactor.save(contract_data, "./Transcript.sol.js")
