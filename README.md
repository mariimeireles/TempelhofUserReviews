This is a project that allows users to browse and submit reviews of the [Tempelhof Tour](https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/). Consuming the GetYourGuide API to retrieve the reviews, using a mocked API to simulate the user submitting a new review (the API documentation is available [here](https://tempelhofuserreviews.docs.apiary.io/)) and [RxSwift](https://github.com/ReactiveX/RxSwift) to handle asynchronous events. Unit tests are included in the application. MVVM is used as the design pattern and concepts as Clean Code and Dependency Injection are also present.

⚠️: as the project uses a mocked API to submit the reviews, the response from this request will always be the same. Therefore after creating a new review, the review list will remain the same. In the real world (without a mocked API), the response will contain the updated review list including the new review.

## Setup:

This application uses:

* macOS High Sierra 10.13.5
* Xcode 9.4
* Swift 4.1
* iOS 10+

## Dependencies

Carthage is used for dependency management. It involves less friction than e.g. Cocoapods.

To run the application, get started with development or after an update by another developer, simply run:

```
$ carthage update --platform ios
```
Ensure that Carthage is set up. To know how to install, check [Carthage docs](https://github.com/Carthage/Carthage#installing-carthage)

## Built With

*[RxSwift](https://github.com/ReactiveX/RxSwift) - To handle asynchronous events. Reactive programming was chosen because of it possible to express static and dynamic data streams with ease and in a more readable way.
*[RxAlamofire](https://github.com/RxSwiftCommunity/RxAlamofire) - To perform networking tasks using RxSwift.
*[Nimble](https://github.com/Quick/Nimble) - To make tests more pleasant to read.

## Run Tests

### Xcode

Go to `Product > Test` or press `command + U`

## Future Steps

as future steps, more Unit and UI tests would be written.
