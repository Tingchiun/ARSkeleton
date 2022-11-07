//
//  SkeletonBone.swift
//  BodyDetection
//
//  Created by ChungTing on 2022/11/7.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import RealityKit

struct SkeletonBone {
    var fromJoint: SkeletonJoint
    var toJoint: SkeletonJoint

    var centerPosition: SIMD3<Float> {
        [(fromJoint.position.x + toJoint.position.x)/2,
         (fromJoint.position.y + toJoint.position.y)/2,
         (fromJoint.position.z + toJoint.position.z)/2]
    }

    var length: Float {
        simd_distance(fromJoint.position, toJoint.position)
    }
}
