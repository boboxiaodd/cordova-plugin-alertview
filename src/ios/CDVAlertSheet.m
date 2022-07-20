#import <Cordova/CDV.h>
#import "CDVAlertSheet.h"
#import <LEEAlert/LEEAlert.h>


@interface CDVAlertSheet ()

@end

@implementation CDVAlertSheet

-(void)alert:(CDVInvokedUrlCommand *)command
{
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSString * title = [options valueForKey:@"title"];
    NSString * text = [options valueForKey:@"text"];
    NSString * done = [options valueForKey:@"done"] ?: @"确定" ;
    int radius = [[options valueForKey:@"raidus"] intValue] ?: 5;
    int fontsize = [[options valueForKey:@"fontsize"] intValue] ?: 14;
    BOOL is_center =  [[options valueForKey:@"center"] boolValue] || NO;
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
        action.titleColor = [UIColor grayColor];
        action.clickBlock = ^{
            [self send_event:command withMessage:@{@"type":@"alert",@"action":@"done"} Alive:NO State:YES];
        };
    });
    actionsheet.config.LeeCornerRadius(radius);
    actionsheet.config.LeeShow();
}
-(void)confirm:(CDVInvokedUrlCommand *)command
{
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSString * title = [options valueForKey:@"title"];
    NSString * text = [options valueForKey:@"text"];
    NSString * done = [options valueForKey:@"done"]  ?: @"确定";
    NSString * cancel = [options valueForKey:@"cancel"] ?: @"取消" ;
    int radius = [[options valueForKey:@"raidus"] intValue] ?: 5;
    int fontsize = [[options valueForKey:@"fontsize"] intValue] ?: 14;
    BOOL is_center =  [[options valueForKey:@"center"] boolValue] || NO;
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
        action.titleColor = [UIColor grayColor];
        action.clickBlock = ^{
            [self send_event:command withMessage:@{@"type":@"confirm",@"action":@"cancel"} Alive:NO State:YES];
        };
    });
    actionsheet.config.LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = done;
        action.titleColor = [UIColor blackColor];
        action.clickBlock = ^{
            [self send_event:command withMessage:@{@"type":@"confirm",@"action":@"done"} Alive:NO State:YES];
        };
    });
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
    int radius = [[options valueForKey:@"raidus"] intValue] ?: 5;
    LEEActionSheetConfig *actionsheet = [LEEAlert actionsheet];
    if (@available(iOS 13.0, *)) {
        actionsheet.config.LeeUserInterfaceStyle(UIUserInterfaceStyleLight);
    }
    actionsheet.config.LeeTitle(title);
    actionsheet.config.LeeContent(text);
    for(int i=0;i<actionlist.count;i++){
        actionsheet.config.LeeAddAction(^(LEEAction * _Nonnull action) {
            action.title = actionlist[i];
            action.titleColor = [UIColor grayColor];
            action.clickBlock = ^{
                [self send_event:command withMessage:@{@"action":actionlist[i]} Alive:NO State:YES];
            };
        });
    }
    actionsheet.config.LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = cancel;
        action.titleColor = [UIColor blackColor];
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
