<template>
  <div id="app">
    <!-- <img src="./assets/logo.png"> -->
    <!-- <router-view/> -->
    <p>constants:</p>
    <dapp-component :dapps="constantdapp" :colors="colorconstant"></dapp-component>
    <p>methods:</p>
    <dapp-component :dapps="methoddapp" :colors="colormethod"></dapp-component>
    </div>
</template>

<script>
/* eslint-disable */
import { default as Web3} from 'web3';
import json from './assets/Transcript.json'
import Vue from 'vue'
import { default as contract } from 'truffle-contract'

var accounts
var account

window.addEventListener('load', function () {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider)
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:7545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask")
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:7545'))
  }
})

var contract_address = "0xf12b5dd4ead5f743c6baa640b0216200e89b60da"

var Transcript = contract(json)
Transcript.defaults({
  from: "0x627306090abab3a6e1400e9345bc60c78a8bef57"
})
Vue.component('dapp-component', {
  props: ['dapps', 'colors'],
  template: '<div><li  v-for="(dapp,index) in dapps"  ><button type="button" :style="{color:colors}" @click="dmethod(dapp.name,$event)" :name="index">{{dapp.name}}</button><input type="text-align" :name="dapp.name" :id="dapp.name" v-model="arr[index]"></li></div>',
  data: function () {
  	return {
  		arr: []
  	}
  },
  methods:{
  	dmethod:function (nameofd,event) {
  		if (event) {
  			var name=event.target.name
  			var value=this.arr[name].toString()
  			// if (!value) {
  			// 	alert("Please insert something!")
  			// }else{
  			// 	alert(value)
  			// }
  			
		    var trans
		    Transcript.at(contract_address).then(function (instance) {
		      trans = instance
          alert('done?')
		      return eval("trans."+nameofd+"("+value+")")
		    }).then(function() {
		    	alert("ok")
		    }).catch(function (e) {
		      console.log(e)
		      alert("wrong")
		    })
  		}
  	}
  }
})

export default {
  name: 'App',
  data: function () {
    return {
	  dapps: json.abi,
      colorconstant: 'green',
      colormethod: 'red',
    }
  },
  computed: {
    constantdapp: function () {
      return this.dapps.filter(function (ddd) {
        return ddd.constant == true
      })
    },
    methoddapp: function () {
      return this.dapps.filter(function (ddd) {
        return ddd.constant == false
      })
    }
  },
  created:function() {
  	// Bootstrap the MetaCoin abstraction for Use.
  	Transcript.setProvider(web3.currentProvider)

  	// Get the initial account balance so it can be displayed.
  	web3.eth.getAccounts(function (err, accs) {
  	if (err != null) {
  		alert('There was an error fetching your accounts.')
  		return
  	}

  	if (accs.length == 0) {
  		alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.")
  		return
  	}

  	accounts = accs
  	account = accounts[0]
  	})
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  margin-top: 60px;
}
</style>
