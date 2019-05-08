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
    dependencies: [],
    targets: [
        .target(
            name: "Objectia"
        ),
        .testTarget(
            name: "ObjectiaTests",
            dependencies: ["Objectia"]),            
    ]
)