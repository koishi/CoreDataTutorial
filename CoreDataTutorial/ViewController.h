//
//  ViewController.h
//  CoreDataTutorial
//
//  Created by bs on 2015/08/16.
//  Copyright (c) 2015年 bs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

