//
//  utility.h
//  vrMobile
//
//  Created by Loud on 6/3/17.
//
//

@interface utility : NSObject
+ (void)showAlertWithTitle:(NSString *)message_title
                andMessage:(NSString *)message
                     andVC:(UIViewController *)vc;

+ (NSArray*)hoursMinutesAndSecondsFromTicks:(long)ticks;
@end
