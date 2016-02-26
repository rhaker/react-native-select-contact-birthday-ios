//
//  RNSelectContactBirthday.m
//  RNSelectContactBirthday
//
//  Created by Ross Haker on 10/22/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "RNSelectContactBirthday.h"

@implementation RNSelectContactBirthday

// Expose this module to the React Native bridge
RCT_EXPORT_MODULE()

// Persist data
RCT_EXPORT_METHOD(selectBirthday:(BOOL *)boolType
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{

    // save the resolve promise
    self.resolve = resolve;

    // set up an error message
    NSError *error = [
                      NSError errorWithDomain:@"some_domain"
                      code:200
                      userInfo:@{
                                 NSLocalizedDescriptionKey:@"ios8 or higher required"
                                 }];


    // detect the ios version
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];

    // check that ios is version 8.0 or higher
    if (ver_float < 8.0) {

        reject(@"200", @"ios8 or higher required", error);

    } else {

        // check permissions
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
            ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){

            // permission denied
            error = [
                     NSError errorWithDomain:@"some_domain"
                     code:300
                     userInfo:@{
                                NSLocalizedDescriptionKey:@"Permissions denied by user."
                                }];

            reject(@"300", @"Permissions denied by user.", error);

        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){

            // permission authorized
            ABPeoplePickerNavigationController *picker;
            picker = [[ABPeoplePickerNavigationController alloc] init];
            picker.peoplePickerDelegate = self;

            UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
            [vc presentViewController:picker animated:YES completion:nil];

        } else {

            // not determined - request permissions
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {

                if (!granted){

                    // user denied access
                    NSError *errorDenied = [
                                            NSError errorWithDomain:@"some_domain"
                                            code:300
                                            userInfo:@{
                                                       NSLocalizedDescriptionKey:@"Permissions denied by user."
                                                       }];

                    reject(@"300", @"Permissions denied by user.", errorDenied);
                    return;
                }

                // user authorized access
                ABPeoplePickerNavigationController *picker;
                picker = [[ABPeoplePickerNavigationController alloc] init];
                picker.peoplePickerDelegate = self;

                UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
                [vc presentViewController:picker animated:YES completion:nil];

            });

        }

    }


}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{

    // initialize the fields
    NSDate *birthday = nil;
    NSString *dateString = nil;

    // get the birthday
    if (ABRecordCopyValue(person, kABPersonBirthdayProperty)) {
        birthday = (__bridge_transfer NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd-yyyy"];
        dateString = [formatter stringFromDate:birthday];
    }

    // check for null values
    NSString *returnBirthday;

    if (dateString) {
        returnBirthday = dateString;
    } else {
        returnBirthday = @"";
    }

    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc dismissViewControllerAnimated:YES completion:nil];

    // resolve the birthday
    self.resolve(returnBirthday);
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{

    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
