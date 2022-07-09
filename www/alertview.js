const exec = require('cordova/exec');
const CDVAlertSheet = {
    alert:function (success,option){
        exec(success,null,'CDVAlertSheet','alert',[option]);
    },
    confirm:function (success,fail,option) {
        exec(success,fail,'CDVAlertSheet','confirm',[option]);
    },
    actionsheet:function (success,option){
        exec(success,null,'CDVAlertSheet','actionsheet',[option]);
    }
};
module.exports = CDVAlertSheet;
