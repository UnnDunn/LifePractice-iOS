//
//  unndunnAppDelegate.h
//  LifePractice
//
//  Created by Uchendu Nwachuku on 1/20/13.
//  Copyright (c) 2013 Uchendu Nwachuku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unndunnAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
