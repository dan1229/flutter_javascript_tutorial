require.config({
    paths:{
        braintree: "https://js.braintreegateway.com/web/dropin/1.32.1/js/dropin.min.js",
    }
});


define(function(require) {
    window.v = require('./scripts/braintree_payment');
});