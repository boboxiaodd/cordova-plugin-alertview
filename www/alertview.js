const exec = require('cordova/exec');
const CDVAlertSheet = {
    alert:function (success,option){
        exec(success,null,'CDVAlertSheet','alert',[option]);
    },
    alert_scl:function (success,option){
        exec(success,null,'CDVAlertSheet','alert_scl',[option]);
    },
    confirm:function (success,option) {
        exec(success,null,'CDVAlertSheet','confirm',[option]);
    },
    confirm_scl:function (success,option) {
        exec(success,null,'CDVAlertSheet','confirm_scl',[option]);
    },
    showLoadding:function (option) {
        exec(null,null,'CDVAlertSheet','showLoadding',[option]);
    },
    hideLoadding:function(){
        exec(null,null,'CDVAlertSheet','hideLoadding',[]);
    }
    actionsheet:function (success,option){
        exec(success,null,'CDVAlertSheet','actionsheet',[option]);
    }
};
module.exports = CDVAlertSheet;
