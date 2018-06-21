//
//  ViewController.swift
//  ARKitFun
//
//  Created by Tyler Frith on 6/21/18.
//  Copyright © 2018 Coty. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    var addedPath = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create session
        configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        
        //add debug options
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.delegate = self
        self.sceneView.delegate = self
        
        // Prevent dimming
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Update the camera settings
        setupCamera()
        
        //create and add node
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }
}

// MARK: - ARSCNViewDelegate Methods
extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        // Place content only for anchors found by plane detection.
        guard let _ = anchor as? ARPlaneAnchor else { return }
        
        print("Possibly found plane")
        if !addedPath {
            // Add the path
            let nodePath = SCNNode()
            nodePath.geometry = SCNCylinder(radius: 0.25, height: 3.0)
            nodePath.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            nodePath.position = SCNVector3(0, 0, -0.5)
            nodePath.rotation = SCNVector4(1, 0, 0, (Double.pi/2))
            nodePath.position = SCNVector3(0, 0, 0)
            nodePath.opacity = 0.5
            
            node.addChildNode(nodePath)
            
            addedPath = true
        } else {
            print("found nodes already")
        }
    }
}

// MARK: - Private Methods
extension ViewController {
    @IBAction private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        addedPath = false
    }
}
