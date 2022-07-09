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
    [LEEAlert alert].config.LeeTitle(title).LeeContent(text).LeeCancelAction(done, ^{
        [self send_event:command withMessage:@{@"type":@"alert",@"action":@"done"} Alive:NO State:YES];
    }).LeeShow();
}
-(void)confirm:(CDVInvokedUrlCommand *)command
{
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSString * title = [options valueForKey:@"title"];
    NSString * text = [options valueForKey:@"text"];
    NSString * done = [options valueForKey:@"done"]  ?: @"确定";
    NSString * cancel = [options valueForKey:@"cancel"] ?: @"取消" ;
    [LEEAlert alert].config
        .LeeTitle(title)
        .LeeContent(text)
        .LeeAction(done, ^{
            [self send_event:command withMessage:@{@"type":@"confirm",@"action":@"done"} Alive:NO State:YES];
        })
        .LeeCancelAction(cancel, ^{
            [self send_event:command withMessage:@{@"type":@"confirm",@"action":@"cancel"} Alive:NO State:YES];
        }).LeeShow();
}
-(void)actionsheet:(CDVInvokedUrlCommand *)command
{
    NSDictionary *options = [command.arguments objectAtIndex: 0];
    NSString * title = [options valueForKey:@"title"];
    NSString * text = [options valueForKey:@"text"];
    NSString * cancel = [options valueForKey:@"cancel"] ?: @"取消" ;
    NSArray * action = [options objectForKey:@"list"];
    [LEEAlert actionsheet].config
        .LeeTitle(title)
        .LeeContent(text)
        .LeeActionSheetBottomMargin(0)
        .LeeActionSheetHeaderCornerRadii(CornerRadiiMake(0, 0, 0, 0))
        .LeeActionSheetCancelActionCornerRadii(CornerRadiiMake(0, 0, 0, 0))
        .LeeAction(cancel, nil)
        .LeeShow();
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
