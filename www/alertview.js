const exec = require('cordova/exec');
const CDVAlertSheet = {
    alert:function (success,option){
        exec(success,null,'CDVAlertSheet','alert',[option]);
    },
    confirm:function (success,option) {
        exec(success,null,'CDVAlertSheet','confirm',[option]);
    },
    actionsheet:function (success,option){
        exec(success,null,'CDVAlertSheet','actionsheet',[option]);
    }
};
module.exports = CDVAlertSheet;
