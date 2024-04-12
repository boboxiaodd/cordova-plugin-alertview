#import <Cordova/CDV.h>
#import "CDVAlertSheet.h"
#import <LEEAlert/LEEAlert.h>
#import "UIColor+BBVoiceRecord.h"
#import "SCLAlertView.h"

@interface CDVAlertSheet ()
    @property (nonatomic,strong)SCLAlertView *loadding;
@end

@implementation CDVAlertSheet

-(void)alert_scl:(NSDictionary *)options withCommand:(CDVInvokedUrlCommand *)command
{
    NSString * title = [options valueForKey:@"title"];
    NSString * text = [options valueForKey:@"text"];
    NSString * done = [options valueForKey:@"done"] ?: @"确定" ;
    int done_bg_color = [[options valueForKey:@"done_bg_color"] intValue] ?: 0xcccccc;
    int done_text_color = [[options valueForKey:@"done_text_color"] intValue] ?: 0x111111;
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth: [UIScreen mainScreen].bounds.size.width * 0.73];
    SCLButton *doneBtn = [alert addButton: done actionBlock:^(void) {
        [self send_event:command withMessage:@{@"type":@"confirm",@"action":@"done"} Alive:NO State:YES];
    }];
    doneBtn.buttonFormatBlock = ^NSDictionary *{
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor colorWithHex: done_bg_color];
        buttonConfig[@"textColor"] = [UIColor colorWithHex: done_text_color];
        return buttonConfig;
    };
    [alert showInfo: title subTitle: text closeButtonTitle: nil duration:0.0f];
}

-(void)confirm_scl:(NSDictionary *)options withCommand:(CDVInvokedUrlCommand *)command
{
    NSString * title = [options valueForKey:@"title"];
    NSString * text = [options valueForKey:@"text"];
    NSString * done = [options valueForKey:@"done"]  ?: @"确定";
    int cancel_bg_color = [[options valueForKey:@"cancel_bg_color"] intValue] ?: 0xcccccc;
    int cancel_text_color = [[options valueForKey:@"cancel_text_color"] intValue] ?: 0x666666;
    int done_bg_color = [[options valueForKey:@"done_bg_color"] intValue] ?: 0xcccccc;
    int done_text_color = [[options valueForKey:@"done_text_color"] intValue] ?: 0x111111;
    
    
    NSString * cancel = [options valueForKey:@"cancel"] ?: @"取消" ;
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth: [UIScreen mainScreen].bounds.size.width * 0.73];
    
    SCLButton *doneBtn = [alert addButton: done actionBlock:^(void) {
        [self send_event:command withMessage:@{@"type":@"confirm",@"action":@"done"} Alive:NO State:YES];
    }];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    doneBtn.buttonFormatBlock = ^NSDictionary *{
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor colorWithHex: done_bg_color];
        buttonConfig[@"textColor"] = [UIColor colorWithHex: done_text_color];
        return buttonConfig;
    };
    
    SCLButton *cancelBtn = [alert addButton: cancel actionBlock:^(void) {
        [self send_event:command withMessage:@{@"type":@"confirm",@"action":@"cancel"} Alive:NO State:YES];
    }];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    cancelBtn.buttonFormatBlock = ^NSDictionary *{
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor colorWithHex: cancel_bg_color];
        buttonConfig[@"textColor"] = [UIColor colorWithHex: cancel_text_color];
        return buttonConfig;
    };
    
    [alert showQuestion:title subTitle:text closeButtonTitle: nil duration:0.0f];
}

-(void)showLoadding:(NSDictionary *)options
{
    NSString * text = [options valueForKey:@"text"];
    _loadding = [[SCLAlertView alloc] initWithNewWindow];
    _loadding.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    _loadding.hideAnimationType = SCLAlertViewHideAnimationFadeOut;
    [_loadding showWaiting:text subTitle:nil closeButtonTitle:nil duration:5.0f];
}


-(void)alert:(CDVInvokedUrlCommand *)command
{
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    if(options[@"useSCL"] != nil){
        [self alert_scl:options withCommand:command];
        return;
    }
    if(options[@"useShowLoadding"] != nil){
        [self showLoadding:options];
        return;
    }
    if(options[@"useHideLoadding"] != nil){
        if(_loadding){
            [_loadding hideView];
        }
        return;
    }
    
    NSString * title = [options valueForKey:@"title"];
    NSString * text = [options valueForKey:@"text"];
    NSString * done = [options valueForKey:@"done"] ?: @"确定" ;
    int radius = [[options valueForKey:@"raidus"] intValue] ?: 5;
    int fontsize = [[options valueForKey:@"fontsize"] intValue] ?: 14;
    BOOL is_center =  [[options valueForKey:@"center"] boolValue] || NO;
    int animation_open = [[options valueForKey:@"animation_open"] intValue] ?: 8;
    int animation_close = [[options valueForKey:@"animation_close"] intValue] ?: 16;

    LEEAlertConfig *actionsheet = [LEEAlert alert];
    if (@available(iOS 13.0, *)) {
        actionsheet.config.LeeUserInterfaceStyle(UIUserInterfaceStyleLight);
    }
    actionsheet.config.LeeTitle(title);
    actionsheet.config.LeeAddContent(^(UILabel * _Nonnull label) {
            label.text = text;
            label.textAlignment = is_center ? NSTextAlignmentCenter : NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:fontsize];
    });
    actionsheet.config.LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = done;
        action.titleColor = [UIColor colorWithHex:0x23282C]; //#23282C
        action.clickBlock = ^{
            [self send_event:command withMessage:@{@"type":@"alert",@"action":@"done"} Alive:NO State:YES];
        };
    });
    actionsheet.config.LeeOpenAnimationStyle(animation_open);
    actionsheet.config.LeeCloseAnimationStyle(animation_close);
    actionsheet.config.LeeCornerRadius(radius);
    actionsheet.config.LeeShow();
}
-(void)confirm:(CDVInvokedUrlCommand *)command
{
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    if(options[@"useSCL"] != nil){
        [self confirm_scl:options withCommand: command];
        return;
    }
    
    NSString * title = [options valueForKey:@"title"];
    NSString * text = [options valueForKey:@"text"];
    NSString * done = [options valueForKey:@"done"]  ?: @"确定";
    NSString * cancel = [options valueForKey:@"cancel"] ?: @"取消" ;
    int radius = [[options valueForKey:@"raidus"] intValue] ?: 5;
    int fontsize = [[options valueForKey:@"fontsize"] intValue] ?: 14;
    BOOL is_center =  [[options valueForKey:@"center"] boolValue] || NO;
    int animation_open = [[options valueForKey:@"animation_open"] intValue] ?: 8;
    int animation_close = [[options valueForKey:@"animation_close"] intValue] ?: 16;
    LEEAlertConfig *actionsheet = [LEEAlert alert];
    if (@available(iOS 13.0, *)) {
        actionsheet.config.LeeUserInterfaceStyle(UIUserInterfaceStyleLight);
    }
    actionsheet.config.LeeTitle(title);
    actionsheet.config.LeeAddContent(^(UILabel * _Nonnull label) {
            label.text = text;
            label.textAlignment = is_center ? NSTextAlignmentCenter : NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:fontsize];
    });
    actionsheet.config.LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = cancel;
        action.titleColor = [UIColor colorWithHex:0x23282C];
        action.clickBlock = ^{
            [self send_event:command withMessage:@{@"type":@"confirm",@"action":@"cancel"} Alive:NO State:YES];
        };
    });
    actionsheet.config.LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = done;
        action.titleColor = [UIColor colorWithHex:0x23282C];
        action.clickBlock = ^{
            [self send_event:command withMessage:@{@"type":@"confirm",@"action":@"done"} Alive:NO State:YES];
        };
    });
    actionsheet.config.LeeOpenAnimationStyle(animation_open);
    actionsheet.config.LeeCloseAnimationStyle(animation_close);
    actionsheet.config.LeeCornerRadius(radius);
    actionsheet.config.LeeShow();
}
-(void)actionsheet:(CDVInvokedUrlCommand *)command
{
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSString * title = [options valueForKey:@"title"];
    NSString * text = [options valueForKey:@"text"];
    NSString * cancel = [options valueForKey:@"cancel"] ?: @"取消" ;
    NSArray * actionlist = [options objectForKey:@"list"];
    int radius = [[options valueForKey:@"raidus"] intValue] ?: 0;
    LEEActionSheetConfig *actionsheet = [LEEAlert actionsheet];
    if (@available(iOS 13.0, *)) {
        actionsheet.config.LeeUserInterfaceStyle(UIUserInterfaceStyleLight);
    }
    actionsheet.config.LeeTitle(title);
    if(text){
        actionsheet.config.LeeContent(text);
    }
    for(int i=0;i<actionlist.count;i++){
        actionsheet.config.LeeAddAction(^(LEEAction * _Nonnull action) {
            action.title = actionlist[i];
            action.titleColor = [UIColor blackColor];
            action.clickBlock = ^{
                [self send_event:command withMessage:@{@"action":actionlist[i]} Alive:NO State:YES];
            };
        });
    }
    actionsheet.config.LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = cancel;
        action.titleColor = [UIColor redColor];
    });
    actionsheet.config.LeeActionSheetBottomMargin(0.0f);
    actionsheet.config.LeeActionSheetCancelActionSpaceColor([UIColor colorWithWhite:0.92 alpha:1.0f]);
    actionsheet.config.LeeActionSheetBackgroundColor([UIColor whiteColor]); // 通过设置背景颜色来填充底部间隙
    actionsheet.config.LeeMaxWidth([UIScreen mainScreen].bounds.size.width);
    actionsheet.config.LeeCornerRadius(radius);
    actionsheet.config.LeeShow();
}


#pragma mark 公共函数

- (void)send_event:(CDVInvokedUrlCommand *)command withMessage:(NSDictionary *)message Alive:(BOOL)alive State:(BOOL)state{
    if(!command) return;
    CDVPluginResult* res = [CDVPluginResult resultWithStatus: (state ? CDVCommandStatus_OK : CDVCommandStatus_ERROR) messageAsDictionary:message];
    if(alive) [res setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult: res callbackId: command.callbackId];
}

-(void)touchfeedback
{
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [feedBackGenertor impactOccurred];
}

@end
