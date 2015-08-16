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

  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  // appDelegate.managedObjectContextを参照
  AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
  self.managedObjectContext = appDelegate.managedObjectContext;
  
  // タイトルを設定する。
  self.title = @"Locations";

  // ボタンをセットアップする。
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                 target:self
                                                                 action:@selector(addEvent)];
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
  
  
  // フェッチ
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event"
                                            inManagedObjectContext:self.managedObjectContext];
  [request setEntity:entity];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                      initWithKey:@"creationDate" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error = nil;
  NSMutableArray *mutableFetchResults = [[self.managedObjectContext
                                          executeFetchRequest:request error:&error] mutableCopy];
  if (mutableFetchResults == nil) { // エラーを処理する。
  }

  self.eventsArray = mutableFetchResults;
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

  // tableView向け処理
  [self.eventsArray insertObject:event atIndex:0];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                        withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // タイムスタンプ用の日付フォーマッタ
  static NSDateFormatter *dateFormatter = nil; if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  }
  // 緯度と経度用の数値フォーマッタ
  static NSNumberFormatter *numberFormatter = nil; if (numberFormatter == nil) {
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:3];
  }
  
  static NSString *CellIdentifier = @"Cell";
  // 新規セルをデキューまたは作成する
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }

  Event *event = (Event *)[self.eventsArray objectAtIndex:indexPath.row];
  cell.textLabel.text = [dateFormatter stringFromDate:[event creationDate]];
  NSString *string = [NSString stringWithFormat:@"%@, %@",
                      [numberFormatter stringFromNumber:[event latitude]],     [numberFormatter stringFromNumber:[event longitude]]];
  cell.detailTextLabel.text = string;
  return cell;
}

@end
