/* eslint-disable func-names */
// eslint-disable-next-line @typescript-eslint/no-var-requires
const exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
  exec(success, error, 'CustomFCMReceiverPlugin', 'coolMethod', [arg0]);
};

exports.onMessageReceived = function (success, error) {
  exec(success, error, 'CustomFCMReceiverPlugin', 'onMessageReceived');
};