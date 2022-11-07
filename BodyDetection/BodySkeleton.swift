//
//  BodySkeleton.swift
//  BodyDetection
//
//  Created by ChungTing on 2022/11/7.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import ARKit
import RealityKit

class BodySkeleton: Entity {
    var joints: [String: Entity] = [:]
    var bones: [String: Entity] = [:]

    var hipEntity: Entity? {
        return joints["hips_joint"]
    }

    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()

        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            var joinRadius: Float = 0.05
            var jointColor: UIColor = .green

            // joints can be check in here : https://developer.apple.com/documentation/arkit/content_anchors/validating_a_model_for_motion_capture?language=objc
            switch jointName {
            case "head_joint":
                joinRadius *= 1
            case "neck_1_joint", "neck_2_joint", "neck_3_joint", "neck_4_joint", "left_shoulder_1_joint", "right_shoulder_1_joint":
                joinRadius *= 0.5
            case "jaw_joint", "chin_joint", "left_eye_joint", "left_eyeLowerLid_joint", "left_eyeUpperLid_joint", "left_eyeball_joint", "nose_joint", "right_eye_joint", "right_eyeLowerLid_joint", "right_eyeUpperLid_joint", "right_eyeball_joint":
                joinRadius *= 0.2
                jointColor = .yellow
                continue
            case _ where jointName.hasPrefix("spine_"):
                joinRadius *= 0.5
                jointColor = .green
            case _ where jointName.hasPrefix("left_hand") || jointName.hasPrefix("right_hand"):
                joinRadius *= 0.25
                jointColor = .yellow
                // continue
            case _ where jointName.hasPrefix("left_toes") || jointName.hasPrefix("right_toes"):
                joinRadius *= 0.5
                jointColor = .yellow
                // continue
            default:
                joinRadius = 0.05
                jointColor = .green
            }

            let jointEntity = createJoint(radius: joinRadius, color: jointColor)
            joints[jointName] = jointEntity
            self.addChild(jointEntity)
        }

        for bone in Bones.allCases {
            guard let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor) else { continue }
            let boneEntity = createBoneEntity(for: skeletonBone)
            bones[bone.name] = boneEntity
            self.addChild(boneEntity)
        }
    }

    func update(with bodyAnchor: ARBodyAnchor) {
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        let rootOrientation = Transform(matrix: bodyAnchor.transform).rotation
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName],
                let jointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName) ) {
                let jointEntityOffsetFromRoot = simd_make_float3(jointEntityTransform.columns.3)
                jointEntity.position = rootPosition + rootOrientation.act(jointEntityOffsetFromRoot)
                jointEntity.orientation = Transform(matrix: jointEntityTransform).rotation
            }
        }

        for bone in Bones.allCases {
            let boneName = bone.name
            guard let entity = bones[boneName],
                  let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor) else { continue }
            entity.position = skeletonBone.centerPosition
            entity.look(at: skeletonBone.toJoint.position, from: skeletonBone.centerPosition, relativeTo: nil)
        }
    }

    /*
    func update(with bodyAnchor: ARBodyAnchor) {
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName],
                let jointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName) ) {
                let jointEntityOffsetFromRoot = simd_make_float3(jointEntityTransform.columns.3)
                jointEntity.position = rootPosition + jointEntityOffsetFromRoot
                jointEntity.orientation = Transform(matrix: jointEntityTransform).rotation
            }
        }

        for bone in Bones.allCases {
            let boneName = bone.name
            guard let entity = bones[boneName],
                  let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor) else { continue }
            entity.position = skeletonBone.centerPosition
            entity.look(at: skeletonBone.toJoint.position, from: skeletonBone.centerPosition, relativeTo: nil)
        }
    }
    */


    required init() {
        fatalError("init() has not been implemented")
    }

    private func createJoint(radius: Float, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        return entity
    }

    private func createSkeletonBone(bone: Bones, bodyAnchor: ARBodyAnchor) -> SkeletonBone? {
        guard let fromJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointFromName) ),
              let toJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointToName))
        else {
            return nil
        }

        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        let rootOrientation = Transform(matrix: bodyAnchor.transform).rotation

        let jointFromEntityOffsetFromRoot = simd_make_float3(fromJointEntityTransform.columns.3)
        // let jointFromEntityPosition = jointFromEntityOffsetFromRoot + rootPosition
        let jointFromEntityPosition = rootOrientation.act(jointFromEntityOffsetFromRoot) + rootPosition

        let jointToEntityOffsetFromRoot = simd_make_float3(toJointEntityTransform.columns.3)
        // let jointToEntityPosition = jointToEntityOffsetFromRoot + rootPosition
        let jointToEntityPosition = rootOrientation.act(jointToEntityOffsetFromRoot) + rootPosition

        let fromJoint = SkeletonJoint(name: bone.jointFromName, position: jointFromEntityPosition)
        let toJoint = SkeletonJoint(name: bone.jointToName, position: jointToEntityPosition)

        return SkeletonBone(fromJoint: fromJoint, toJoint: toJoint)
    }
    /*
    private func createSkeletonBone(bone: Bones, bodyAnchor: ARBodyAnchor) -> SkeletonBone? {
        guard let fromJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointFromName) ),
              let toJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointToName))
        else {
            return nil
        }

        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        let jointFromEntityOffsetFromRoot = simd_make_float3(fromJointEntityTransform.columns.3)
        let jointFromEntityPosition = jointFromEntityOffsetFromRoot + rootPosition

        let jointToEntityOffsetFromRoot = simd_make_float3(toJointEntityTransform.columns.3)
        let jointToEntityPosition = jointToEntityOffsetFromRoot + rootPosition

        let fromJoint = SkeletonJoint(name: bone.jointFromName, position: jointFromEntityPosition)
        let toJoint = SkeletonJoint(name: bone.jointToName, position: jointToEntityPosition)

        return SkeletonBone(fromJoint: fromJoint, toJoint: toJoint)
    }
     */


    private func createBoneEntity(for skeletonBone: SkeletonBone, diameter: Float = 0.04, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateBox(size: [diameter, diameter, skeletonBone.length], cornerRadius: diameter/2)
        let material = SimpleMaterial(color: color, roughness: 0.5, isMetallic: true)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        return entity
    }
}
