# PJFDataSource

[![CI Status](https://travis-ci.org/square/PJFDataSource.svg?branch=master)](https://travis-ci.org/square/PJFDataSource)
[![Version](https://img.shields.io/cocoapods/v/PJFDataSource.svg)](http://cocoadocs.org/docsets/PJFDataSource)
[![License](https://img.shields.io/cocoapods/l/PJFDataSource.svg)](http://cocoadocs.org/docsets/PJFDataSource)
[![Platform](https://img.shields.io/cocoapods/p/PJFDataSource.svg)](http://cocoadocs.org/docsets/PJFDataSource)

PJFDataSource is a small library that provides a simple, clean architecture for your app to manage its data sources while providing a consistent user interface for common content states (i.e. loading, loaded, empty, and error).

## Inspiration

PJFDataSource was built as a simpler and more focused alternative to Apple's AdvancedCollectionView sample code which was originally introduced in the 2014 WWDC presentation [Advanced User Interfaces with Collection Views](https://developer.apple.com/videos/play/wwdc2014/232/).

We keep the basic patterns that we like, but discard most of the more complex features. For example, PJFDataSource doesn't have any built-in support for "aggregate data sources". Nor does it do any handling of your actual view's content (e.g. configuring and displaying UICollectionViewCells). It doesn't even require you to use a UICollectionView. Your app remains responsible for providing and configuring your user interface's content view, giving you the flexibility to choose a table view, collection view, stack view, etc.

## Installation

### CocoaPods

To install PJFDataSource in your iOS project, install with [CocoaPods](http://cocoapods.org):

```ruby
platform :ios, '8.0'
pod 'PJFDataSource'
```

## Demo

To see the featureset of PJFDataSource in a more concrete way, check out the simplistic demo app included in this repository.

1. Clone this repository to your machine
2. Open `PJFDataSource.xcodeproj` in Xcode
3. Switch your Target to PJFDataSourceDemoApp and Run

The demo app will open in the iOS Simulator, presenting you with a table view showing a bunch of colored rows. This is our simplistic content view, a UITableView. The three buttons at the top of the view, labeled "Success", "Empty" and "Error" simply tell the demo app to reload it's content, and simulate either a successful response, an empty response, or an error response. Give each of these a try and notice:

* Tapping any of the buttons triggers a reload of the content. Notice that the UI transitions to show a loading indicator while we wait for the asynchronous data load. The loading indicator image can be customized using the `UIAppearance` protocol on `PJFLoadingView`.
* Tapping the "Empty" button will simulate the data source loading without error, but determining it has no content to show (see `-[PJFDataSource hasContent]`). The UI provides a way of displaying an image/title/message and action, configured via your `PJFContentWrapperViewDelegate`. The appearance of this placeholder view can be customized using the `UIAppearance` protocol on `PJFImageTitleMessageView`.
* Tapping the "Error" button will simulate an error loading content and provide a similar placeholder UI. Your `PJFContentWrapperViewDelegate` is provided the underlying `NSError` object, so you can customize the UI based on the specific error.
* Try tapping one of the buttons several times in a row, then quickly tapping a different button. You'll see that the final UI will reflect your final tap, ignoring responses from the earlier requests. See `PJFLoadingCoordinator` and the single-boolean "state machine" `PJFLoadingState`.

That's really all there is to it!

## Usage

There are two primary interaction points between your app and PJFDataSource are:

* `PJFContentWrapperView`, the wrapper view you'll insert into your view hierarchy. PJFDataSource components will work with the content wrapper view to switch between your app-provided content view and the PJFDataSource-provided views for loading/empty/error states.
* `PJFDataSource`, an abstract class which you'll subclass for each of your data sources. The data source is responsible for loading content, updating its internal model to reflect the loaded content, and notifying of success/failure via its `loadingCoordinator`. Often, your data source will also serve as the data source for your content view (e.g. as the `UITableViewDataSource` for a `UITableView`).

Basic integration into your app looks like this:

1.  Create the view controller that will own the content view you want to show.
2.  In the view controller, instantiate a `PJFContentWrapperView` using `initWithFrame:contentView:`, passing in your content view of choice (e.g. a `UITableView`). Insert the wrapper view into the appropriate place in your view hierarchy—likely as a full-size subview of your root `view`. Although not required, you will likely want to set your view controller as the `PJFContentWrapperViewDelegate` of the wrapper view, and implement at least `willShowNoContentView:` and `willShowErrorView:` so that you can customize the content of these placeholder views.
3.  In the view controller, instantiate your `PJFDataSource` subclass (see below), with your view controller as the delegate. Implement `contentWrapperViewForDataSource:`, the single required method on the `PJFDataSourceDelegate` protocol, having it return the content wrapper view created above.
4.  In the view controller's `viewWillAppear:` method, call `loadContent` on your data source.

You've now got your own `PJFDataSource` subclass instance. You're telling it to load when your view controller appears. The data source does its work and updates the content wrapper view appropriately. Ta-da!

    
### Example `-[PJFDataSource loadContent]`

Implementing your `loadContent` method correctly is important and not entirely obvious from the API. The key is that the PJFDataSource instance uses its provided `PJFLoadingCoordinator` to actually kick off the load, as well as to notify of success/failure. See this example, taken directly from the demo app:

```objective-c
- (void)loadContent;
{    
    [self.loadingCoordinator loadContentWithBlock:^(PJFLoadingState *loadingState) {
        [self.colorsLoader asyncLoadColorsWithSuccess:^(NSArray *colors) {
            if (!loadingState.valid) {
                return;
            }
            
            self.colors = colors;
            
            [self.loadingCoordinator loadContentDidFinishWithError:nil];
            
        } error:^(NSError *error) {
            if (!loadingState.valid) {
                return;
            }
            
            [self.loadingCoordinator loadContentDidFinishWithError:error];            
        }];
    }];
}
```

The `self.loadingCoordinator` object is provided by the PJFDataSource base class. When you start loading your content, do so via the `loadContentWithBlock:` method. This allows the loading coordinator to know when you start loading and allows it to provide a `PJFLoadingState` object so we can ignore incoming responses from obsolete requests (i.e. invalidated by a more recent request).

Within the `loadContentWithBlock:` block, you'll kick off your async loading task with callbacks for completion. In this case we're using another object (`self.colorsLoader`) to do the heavy lifting. In our completion blocks, we check the `loadingState` to determine if it is still current. If it isn't, we ignore this response by returning immediately. If it's still current, then we'll update our internal model (e.g. `self.colors = colors;`) and then notify our `loadingCoordinator` of success or failure via `loadContentDidFinishWithError:`.

### Appearance Styling

PJFDataSource provides for limited appearance styling via the [UIAppearance](http://nshipster.com/uiappearance/) mechanism. See the properties marked with `UI_APPEARANCE_SELECTOR` in `PJFLoadingView` and `PJFContentWrapperView`. Also see the demo app's `AppAppearance` class, whose sole purpose is to set up the appearance styling.

## Missing Features

We want to keep PJFDataSource simple, but there are some things we know we'd like to add:

* Increased customizability of PJFImageTitleMessageView via the `UIAppearance` protocol
* Customization of the animation (currently a rotation) applied to the PJFLoadingView's loading image 

If you'd like to help, see "Contributing" below.

## Requirements

* iOS 8 or later.

## Contributing

We’re glad you’re interested in PJFDataSource, and we’d love to see where you take it. Please read our [contributing guidelines](Contributing.md) prior to submitting a Pull Request.


![Fry Meme wondering about PJFDataSource's name prefix](https://cdn.meme.am/instances/500x/68845616.jpg)
