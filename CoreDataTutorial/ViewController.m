//
//  ViewController.m
//  CoreDataTutorial
//
//  Created by bs on 2015/08/16.
//  Copyright (c) 2015年 bs. All rights reserved.
//

#import "ViewController.h"
#import "Event.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // appDelegate.managedObjectContextを参照
  AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
  self.managedObjectContext = appDelegate.managedObjectContext;
  
  // タイトルを設定する。 self.title = @"Locations";
  // ボタンをセットアップする。 self.navigationItem.leftBarButtonItem = self.editButtonItem;
  self.addButton = [[UIBarButtonItem alloc]
               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
               target:self action:@selector(addEvent)];
  self.addButton.enabled = NO;
  self.navigationItem.rightBarButtonItem = self.addButton;

  // locationManagerの処理
  self.locationManager = [CLLocationManager new];
  [self.locationManager setDelegate:self];
  [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
  [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
  
  if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    [self.locationManager requestWhenInUseAuthorization];
  }
  
  [[self locationManager] startUpdatingLocation];
}

- (void)viewDidUnload {
  self.eventsArray = nil;
  self.locationManager = nil;
  self.addButton = nil;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark -

// サンプルのこの実装エラーになるのでコメント化、viewDidLoadに仮実装
//- (CLLocationManager *)locationManager {
//  if (self.locationManager != nil) {
//    return self.locationManager;
//  }
//  self.locationManager = [[CLLocationManager alloc] init];
//  self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//  self.locationManager.delegate = self;
//  return self.locationManager;
//}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  self.addButton.enabled = YES;
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  self.addButton.enabled = NO;
}

- (void)addEvent
{
  CLLocation *location = [self.locationManager location];
  if (!location) {
    return;
  }

  // Eventエンティティの新規インスタンスを作成して設定する
  Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                        inManagedObjectContext:self.managedObjectContext];
  CLLocationCoordinate2D coordinate = [location coordinate];
  [event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
  [event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
  [event setCreationDate:[NSDate date]];

  NSError *error = nil;
  if (![self.managedObjectContext save:&error]) {
    // エラーを処理する。
  }
}

@end
