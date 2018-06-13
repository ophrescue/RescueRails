<template>
  <div id="app">
    <p>{{ message }}</p>
  </div>
</template>

<script>
import queryString from 'query-string'
// const queryString = require('query-string');
// 
// console.log(location.search);
// //=> '?foo=bar'
// 
const parsed = queryString.parse(location.search);
console.log(parsed);
// //=> {foo: 'bar'}
// 
// console.log(location.hash);
// //=> '#token=bada55cafe'
// 
// const parsedHash = queryString.parse(location.hash);
// console.log(parsedHash);
// //=> {token: 'bada55cafe'}
// 
// parsed.foo = 'unicorn';
// parsed.ilike = 'pizza';
// 
// const stringified = queryString.stringify(parsed);
// //=> 'foo=unicorn&ilike=pizza'
// 
// location.search = stringified;
// // note that `location.search` automatically prepends a question mark
// console.log(location.search);
// //=> '?foo=unicorn&ilike=pizza'

var message = "who let the canary out"

export default {
  data: function () {
    return {
      message: parsed
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
