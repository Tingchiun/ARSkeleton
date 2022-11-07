//
//  Bones.swift
//  BodyDetection
//
//  Created by ChungTing on 2022/11/7.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation

enum Bones: CaseIterable {
    case leftShoulderToLeftArm
    case leftArmToLeftForeArm
    case leftForeArmToLeftHand

    case rightShoulderToRightArm
    case rightArmToRightForeArm
    case rightForeArmToRightHand

    case spine7ToLeftShoulder
    case spine7ToRightShoulder

    case neck1ToSpine7
    case spine7ToSpine6
    case spine6ToSpine5

    case hipeToLeftUpLeg
    case leftUpLegToLeftLeg
    case leftLegToLeftFoot

    case hipeToRightUpLeg
    case rightUpLegToRightLeg
    case rightLegToRightFoot

    var name: String {
        return "\(self.jointFromName) - \(self.jointToName)"
    }

    var jointFromName: String {
        switch self {

        case .leftShoulderToLeftArm:
            return "left_shoulder_1_joint"
        case .leftArmToLeftForeArm:
            return "left_arm_joint"
        case .leftForeArmToLeftHand:
            return "left_forearm_joint"

        case .rightShoulderToRightArm:
            return "right_shoulder_1_joint"
        case .rightArmToRightForeArm:
            return "right_arm_joint"
        case .rightForeArmToRightHand:
            return "right_forearm_joint"

        case .spine7ToLeftShoulder:
            return "spine_7_joint"
        case .spine7ToRightShoulder:
            return "spine_7_joint"

        case .neck1ToSpine7:
            return "neck_1_joint"
        case .spine7ToSpine6:
            return "spine_7_joint"
        case .spine6ToSpine5:
            return "spine_6_joint"

        case .hipeToLeftUpLeg:
            return "hips_joint"
        case .leftUpLegToLeftLeg:
            return "left_upLeg_joint"
        case .leftLegToLeftFoot:
            return "left_leg_joint"

        case .hipeToRightUpLeg:
            return "hips_joint"
        case .rightUpLegToRightLeg:
            return "right_upLeg_joint"
        case .rightLegToRightFoot:
            return "right_leg_joint"
        }
    }

    var jointToName: String {
        switch self {

        case .leftShoulderToLeftArm:
            return "left_arm_joint"
        case .leftArmToLeftForeArm:
            return "left_forearm_joint"
        case .leftForeArmToLeftHand:
            return "left_hand_joint"

        case .rightShoulderToRightArm:
            return "right_arm_joint"
        case .rightArmToRightForeArm:
            return "right_forearm_joint"
        case .rightForeArmToRightHand:
            return "right_hand_joint"

        case .spine7ToLeftShoulder:
            return "left_shoulder_1_joint"
        case .spine7ToRightShoulder:
            return "right_shoulder_1_joint"

        case .neck1ToSpine7:
            return "spine_7_joint"
        case .spine7ToSpine6:
            return "spine_6_joint"
        case .spine6ToSpine5:
            return "spine_5_joint"

        case .hipeToLeftUpLeg:
            return "left_upLeg_joint"
        case .leftUpLegToLeftLeg:
            return "left_leg_joint"
        case .leftLegToLeftFoot:
            return "left_foot_joint"

        case .hipeToRightUpLeg:
            return "right_upLeg_joint"
        case .rightUpLegToRightLeg:
            return "right_leg_joint"
        case .rightLegToRightFoot:
            return "right_foot_joint"
        }
    }

}
