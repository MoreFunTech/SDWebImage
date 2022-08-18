/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <SDWebImage/SDWebImage.h>



@interface MasterSDUnit : NSObject <SDWebImagePluginProtocol>

@end

@implementation MasterSDUnit

- (SDWebImagePluginFirstDownloadFailureUnit *)firstDownloadFailWithUrl:(NSURL *)url {
    NSLog(@"\n [First Download Failed]\n [OriginUrl: %@]\n [DecodeUrl: %@]", url, @"");
    SDWebImagePluginFirstDownloadFailureUnit *unit = [[SDWebImagePluginFirstDownloadFailureUnit alloc] init];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf configureFirstDownloadUnitWithUrl:url unit:unit];
    });
    return unit;
}

- (void)configureFirstDownloadUnitWithUrl:(NSURL *)url unit:(SDWebImagePluginFirstDownloadFailureUnit *)unit {
    NSString *decodeUrlStr = @"http://p1-q.mafengwo.net/s11/M00/B6/7B/wKgBEFt_tvGAFvHxAAFIRKQnOBw21.jpeg";
    if (unit.redownloadReadyBlock) {
        unit.redownloadReadyBlock(decodeUrlStr);
    }
}

- (void)downloadSuccessWithOriginUrl:(NSURL *)originUrl decodeUrl:(NSURL *)decodeUrl {
    NSLog(@"\n [Download Success]\n [OriginUrl: %@]\n [DecodeUrl: %@]", originUrl, decodeUrl);
}

- (void)reDownloadFailWithOriginUrl:(nonnull NSURL *)originUrl decodeUrl:(nonnull NSURL *)decodeUrl {
    NSLog(@"\n [Re Download Failed]\n [OriginUrl: %@]\n [DecodeUrl: %@]", originUrl, decodeUrl);
}


@end

@interface MyCustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *customTextLabel;
@property (nonatomic, strong) SDAnimatedImageView *customImageView;

@end

@implementation MyCustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _customImageView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(20.0, 2.0, 60.0, 40.0)];
        [self.contentView addSubview:_customImageView];
        _customTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 12.0, 200, 20.0)];
        [self.contentView addSubview:_customTextLabel];
        
        _customImageView.clipsToBounds = YES;
        _customImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

@end

@interface MasterViewController ()

@property (nonatomic, strong) MasterSDUnit *unit;
@property (nonatomic, strong) NSMutableArray<NSString *> *objects;

@end

@implementation MasterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"SDWebImage";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithTitle:@"Clear Cache"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(flushCache)];
        
        self.unit = [[MasterSDUnit alloc] init];
        SDWebImagePluginManager.shareManager.pluginDelegate = self.unit;
        
        // HTTP NTLM auth example
        // Add your NTLM image url to the array below and replace the credentials
        [SDWebImageDownloader sharedDownloader].config.username = @"httpwatch";
        [SDWebImageDownloader sharedDownloader].config.password = @"httpwatch01";
        [[SDWebImageDownloader sharedDownloader] setValue:@"SDWebImage Demo" forHTTPHeaderField:@"AppName"];
        [SDWebImageDownloader sharedDownloader].config.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
        
        self.objects = [NSMutableArray arrayWithObjects:
                    @"http://p1-q.mafengwo.net/s11/M00/B6/7B/wKgBEFt_tvGAFvHxAAFIRKQnOBw211.jpeg",     // requires HTTP auth, used to demo the NTLM auth
//                    @"http://assets.sbnation.com/assets/2512203/dogflops.gif",
//                    @"https://raw.githubusercontent.com/liyong03/YLGIFImage/master/YLGIFImageDemo/YLGIFImageDemo/joy1.gif",
//                    @"http://apng.onevcat.com/assets/elephant2.png",
//                    @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
//                    @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
//                    @"http://littlesvr.ca/apng/images/SteamEngine.webp",
//                    @"http://littlesvr.ca/apng/images/world-cup-2014-42.webp",
//                    @"https://isparta.github.io/compare-webp/image/gif_webp/webp/2.webp",
//                    @"https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic",
//                    @"https://nokiatech.github.io/heif/content/image_sequences/starfield_animation.heic",
//                    @"https://s2.ax1x.com/2019/11/01/KHYIgJ.gif",
//                    @"https://raw.githubusercontent.com/icons8/flat-color-icons/master/pdf/stack_of_photos.pdf",
//                    @"https://nr-platform.s3.amazonaws.com/uploads/platform/published_extension/branding_icon/275/AmazonS3.png",
//                    @"http://via.placeholder.com/200x200.jpg",
                    nil];
        
        for (int i = 1; i < 50; i++) {
            [self.objects addObject:@"http://p1-q.mafengwo.net/s11/M00/B6/7B/wKgBEFt_tvGAFvHxAAFIRKQnOBw211.jpeg"];
        }

//        for (int i=1; i<25; i++) {
//            // From http://r0k.us/graphics/kodak/, 768x512 resolution, 24 bit depth PNG
//            [self.objects addObject:[NSString stringWithFormat:@"http://r0k.us/graphics/kodak/kodak/kodim%02d.png", i]];
//        }
    }
    return self;
}

- (void)flushCache {
    [SDWebImageManager.sharedManager.imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    static UIImage *placeholderImage = nil;
    if (!placeholderImage) {
        placeholderImage = [UIImage imageNamed:@"placeholder"];
    }
    
    MyCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.customImageView.sd_imageTransition = SDWebImageTransition.fadeTransition;
        cell.customImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayIndicator;
    }
    
    cell.customTextLabel.text = [NSString stringWithFormat:@"Image #%ld", (long)indexPath.row];
    __weak SDAnimatedImageView *imageView = cell.customImageView;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.objects[indexPath.row]]
                 placeholderImage:placeholderImage
                          options:0
                          context:@{SDWebImageContextImageThumbnailPixelSize : @(CGSizeMake(180, 120))}
                         progress:nil
                        completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        SDWebImageCombinedOperation *operation = [imageView sd_imageLoadOperationForKey:imageView.sd_latestOperationKey];
        SDWebImageDownloadToken *token = operation.loaderOperation;
        if (@available(iOS 10.0, *)) {
            NSURLSessionTaskMetrics *metrics = token.metrics;
            if (metrics) {
                printf("Metrics: %s download in (%f) seconds\n", [imageURL.absoluteString cStringUsingEncoding:NSUTF8StringEncoding], metrics.taskInterval.duration);
            }
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *largeImageURLString = [self.objects[indexPath.row] stringByReplacingOccurrencesOfString:@"small" withString:@"source"];
    NSURL *largeImageURL = [NSURL URLWithString:largeImageURLString];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailViewController.imageURL = largeImageURL;
    [self.navigationController pushViewController:detailViewController animated:YES];
}




@end



