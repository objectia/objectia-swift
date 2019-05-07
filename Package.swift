// swift-tools-version:4.0
//
//  Package.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import PackageDescription

let package = Package(
    name: "Objectia",
    products: [
        .library(
            name: "Objectia",
            targets: ["Objectia"]),
    ],
    dependencies: [
    //    .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "12.0.0")),
    //    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "Objectia"
      //      dependencies: ["Alamofire"]
        ),
        .testTarget(
            name: "ObjectiaTests",
            dependencies: ["Objectia"]),            
    ]
)