//
//  ViewController.m
//  CoreDataTutorial
//
//  Created by bs on 2015/08/16.
//  Copyright (c) 2015年 bs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

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

@end
