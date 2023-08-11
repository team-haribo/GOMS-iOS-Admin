import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project(
    name: "GOMS-IOS-Admin",
    organizationName: "HARIBO",
    packages: [
        .remote(
            url: "https://github.com/RxSwiftCommunity/RxFlow.git",
            requirement: .upToNextMajor(from: "2.10.0")
        ),
        .remote(
            url: "https://github.com/ReactiveX/RxSwift.git",
            requirement: .upToNextMajor(from: "6.6.0")
        ),
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.0.1")
        ),
        .remote(
            url: "https://github.com/devxoul/Then",
            requirement: .upToNextMajor(from: "2")
        ),
        .remote(
            url: "https://github.com/Moya/Moya.git",
            requirement: .upToNextMajor(from: "15.0.0")
        ),
        .remote(
            url: "https://github.com/onevcat/Kingfisher.git",
            requirement: .upToNextMajor(from: "7.0.0")
        ),
        .remote(
            url: "https://github.com/GSM-MSG/GAuthSignin-Swift",
            requirement: .upToNextMajor(from: "0.0.3")
        ),
        .remote(
            url: "https://github.com/ReactorKit/ReactorKit.git",
            requirement: .upToNextMajor(from: "3.0.0")
        )
    ],
    targets: [
        Target(
            name: "GOMS-IOS-Admin",
            platform: .iOS,
            product: .app,
            bundleId: "io.tuist.GOMSIOSAdmin",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: "Support/Info.plist",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            headers: .headers(
                public: ["Sources/public/A/**", "Sources/public/B/**"],
                private: "Sources/private/**",
                project: ["Sources/project/A/**", "Sources/project/B/**"]
            ),
            dependencies: [
             .package(product: "RxFlow"),
             .package(product: "RxSwift"),
             .package(product: "RxCocoa"),
             .package(product: "SnapKit"),
             .package(product: "Then"),
             .package(product: "Moya"),
             .package(product: "Kingfisher"),
             .package(product: "GAuthSignin"),
             .package(product: "ReatorKit")
            ]
        )
    ]
)
