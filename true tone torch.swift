import UIKit
import AVFoundation

class ViewController: UIViewController {

    let torch = AVCaptureDevice.default(for: AVMediaType.video)?.torch // Get torch object
    var torchLevel: Float = 0.0 // Torch level (brightness)
    var toneLevel: Float = 0.5 // Torch tone (color temperature)
    let brightnessSlider = UISlider() // Slider for brightness
    let toneSlider = UISlider() // Slider for tone
    let statusLabel = UILabel() // Label for torch status
    let window = UIWindow(frame: UIScreen.main.bounds) // Window
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // Set background color to black
        window.backgroundColor = .black
        
        // Add brightness slider
        brightnessSlider.frame = CGRect(x: 20, y: UIScreen.main.bounds.midY - 75, width: UIScreen.main.bounds.width - 40, height: 30)
        brightnessSlider.minimumValue = 0.0
        brightnessSlider.maximumValue = 1.0
        brightnessSlider.value = torchLevel
        brightnessSlider.addTarget(self, action: #selector(brightnessChanged(_:)), for: .valueChanged)
        brightnessSlider.minimumTrackTintColor = .white // Set brightness slider color to white
        view.addSubview(brightnessSlider)
        
        // Add tone slider
        toneSlider.frame = CGRect(x: 20, y: UIScreen.main.bounds.midY - 25, width: UIScreen.main.bounds.width - 40, height: 30)
        toneSlider.minimumValue = 0.0
        toneSlider.maximumValue = 1.0
        toneSlider.value = toneLevel
        toneSlider.addTarget(self, action: #selector(toneChanged(_:)), for: .valueChanged)
        toneSlider.minimumTrackTintColor = UIColor(named: "GoldColor") // Set tone slider color to gold
        view.addSubview(toneSlider)
        
        // Add status label
        statusLabel.frame = CGRect(x: 20, y: UIScreen.main.bounds.midY + 25, width: UIScreen.main.bounds.width - 40, height: 30)
        statusLabel.text = "Torch: OFF"
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
    }
    
    @objc func brightnessChanged(_ sender: UISlider) {
        torchLevel = sender.value
        setTorchLevel(level: torchLevel, tone: toneLevel)
    }
    
    @objc func toneChanged(_ sender: UISlider) {
        toneLevel = sender.value
        setTorchLevel(level: torchLevel, tone: toneLevel)
    }
    
    func setTorchLevel(level: Float, tone: Float) {
        do {
            try torch?.lockForConfiguration()
            try torch?.setTorchModeOn(level: level)
            torch?.setTorchModeOn(level: level)
            torch?.torchColor = UIColor(white: 1.0 - tone, alpha: 1.0)
            torch?.unlockForConfiguration()
            
            // Update status label
            if level > 0 {
                statusLabel.text = "Torch: ON"
            } else {
                statusLabel.text = "Torch: OFF"
            }
        } catch {
            print("Torch could not be used")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
