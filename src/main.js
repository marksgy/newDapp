// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
/* eslint-disable */
import Vue from 'vue'
import App from './App'
import { default as Web3 } from 'web3'
// import router from './router'

Vue.config.productionTip = false



/* eslint-disable no-new */
var mydapp = new Vue({
  el: '#app',
  // router,
  components: { App },
  template: '<App/>',
})


