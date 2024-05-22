//
//  ViewController.swift
//  ElSueloEsLavaAR
//
//  Created by Liquid on 20/5/24.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        
        self.sceneView.delegate = self
        
    }
    
    func createLava(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let lavaNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        lavaNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "lava")
        lavaNode.geometry?.firstMaterial?.isDoubleSided = true
        lavaNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        lavaNode.eulerAngles = SCNVector3(98.degreesToRadians, 0, 0)
        return lavaNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let lavaNode = createLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
        
        print("Nueva superficie horizontal detectado, nuevo ARPlaneAnchor añadido")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        print("El plano se ha actualizado")
        
        node.enumerateChildNodes({(childNode, _) in
            childNode.removeFromParentNode()
        })
        let lavaNode = createLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
    }
    
    func renderer(_ renderer: any SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("El plano ha sido eliminado")
        
        node.enumerateChildNodes({(childNode, _) in
            childNode.removeFromParentNode()
        })
    }
    
}

extension Int{
    var degreesToRadians: Double {return Double(self) * .pi/180 }
}
