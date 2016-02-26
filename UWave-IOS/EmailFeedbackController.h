//
//  EmailFeedbackController.h
//  UWave Radio
//
//  Created by George Urick on 2/25/16.
//  Copyright © 2016 HappDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface EmailFeedbackController : NSObject <MFMailComposeViewControllerDelegate>

+(void)sendFeedback;
+ (EmailFeedbackController *) sharedInstance;

@end
