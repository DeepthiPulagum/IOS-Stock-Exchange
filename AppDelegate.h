//
//  AppDelegate.h
//  RaniaArbash'sProject
//
//  Created by Rania on 2016-12-15.
//  Copyright © 2016 Rania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

