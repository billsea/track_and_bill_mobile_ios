//
//  utility.m
//  vrMobile
//
//  Created by Loud on 6/3/17.
//
//

#import "utility.h"

@implementation utility

+ (void)showAlertWithTitle:(NSString *)message_title
                andMessage:(NSString *)message
                     andVC:(UIViewController *)vc {

    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:message_title
                         message:message
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil)
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){
                               }];

    [alert addAction:defaultAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (NSArray*)hoursMinutesAndSecondsFromTicks:(long)ticks {
		double sec = fmod(ticks, 60.0);
		double m = fmod(trunc(ticks / 60.0), 60.0);
		double h = trunc(ticks / 3600.0);
	
		NSNumber* hours = [NSNumber numberWithDouble:h];
		NSNumber* minutes = [NSNumber numberWithDouble:m];
		NSNumber* seconds = [NSNumber numberWithDouble:sec];
	
	return @[hours, minutes, seconds];
}

@end
