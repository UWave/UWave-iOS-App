//
//  EmailFeedbackController.m
//  UWave Radio
//
//  Created by George Urick on 2/25/16.
//  Copyright © 2016 HappDev. All rights reserved.
//

#import "EmailFeedbackController.h"
#import "Appirater.h"

@interface EmailFeedbackController ()

@end

@implementation EmailFeedbackController



static EmailFeedbackController *sharedInstance = nil;


+(EmailFeedbackController *)sharedInstance {
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [[EmailFeedbackController alloc] init];
        }
        return sharedInstance;
    }
    
}


+ (id)getRootViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    return [EmailFeedbackController iterateSubViewsForViewController:window]; // iOS 8+ deep traverse
}

+ (id)iterateSubViewsForViewController:(UIView *) parentView {
    for (UIView *subView in [parentView subviews]) {
        UIResponder *responder = [subView nextResponder];
        if([responder isKindOfClass:[UIViewController class]]) {
            return [self topMostViewController: (UIViewController *) responder];
        }
        id found = [EmailFeedbackController iterateSubViewsForViewController:subView];
        if( nil != found) {
            return found;
        }
    }
    return nil;
}

+ (UIViewController *) topMostViewController: (UIViewController *) controller {
    BOOL isPresenting = NO;
    do {
        // this path is called only on iOS 6+, so -presentedViewController is fine here.
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            controller = presented;
        }
        
    } while (isPresenting);
    
    return controller;
}
+(void)sendFeedback {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = [EmailFeedbackController sharedInstance];
        [mail setSubject:@"Feedback for UWave Radio"];
        [mail setToRecipients:@[@"happdevuwb@gmail.com"]];
        [[self getRootViewController] presentViewController:mail animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops! 😳" message:@"We can't access your email. Please email happdevuwb@gmail.com to leave feedback!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

/*
 mailCompose is a mail kit delegate method created by George Urick.
 Not officially a part of Appirater.
 */
-(void)mailComposeController:(nonnull MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    if(result == MFMailComposeResultSent) {
        [controller dismissViewControllerAnimated:YES completion:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thanks for the feedback!" message:@"We are always looking to improve our app and appreciate your time!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }];
    }
    else {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
