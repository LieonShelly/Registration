//
//  ColorPicker.swift
//  Registration
//
//  Created by Renjun Li on 2023/8/17.
//

import Foundation
import UIKit
import SnapKit

class ColorPickerView: UIView {
    var colorValueChanged: ((_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> Void)?
    private lazy var redSlider: ColorSlider = {
        let slider = ColorSlider()
        slider.sliderLabel.text = "Red"
        slider.slider.addTarget(self, action: #selector(self.sliderValueChanged), for: .valueChanged)
        return slider
    }()
    private lazy var greenSlider: ColorSlider = {
        let slider = ColorSlider()
        slider.sliderLabel.text = "Green"
        slider.slider.addTarget(self, action: #selector(self.sliderValueChanged), for: .valueChanged)
        return slider
    }()
    private lazy var blueSlider: ColorSlider = {
        let slider = ColorSlider()
        slider.sliderLabel.text = "Blue"
        slider.slider.addTarget(self, action: #selector(self.sliderValueChanged), for: .valueChanged)
        return slider
    }()
    lazy var dismissBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Done", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        addSubview(redSlider)
        addSubview(greenSlider)
        addSubview(blueSlider)
        addSubview(dismissBtn)
        redSlider.snp.makeConstraints {
            $0.bottom.equalTo(greenSlider.snp.top).inset(10)
            $0.left.right.equalTo(greenSlider)
            $0.height.equalTo(60)
            $0.top.equalToSuperview().inset(10)
        }
        greenSlider.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(60)
        }
        blueSlider.snp.makeConstraints {
            $0.top.equalTo(greenSlider.snp.bottom).inset(10)
            $0.left.right.equalTo(greenSlider)
            $0.height.equalTo(60)
        }
        dismissBtn.snp.makeConstraints {
            $0.bottom.equalTo(-10)
            $0.right.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc
    private func sliderValueChanged() {
        colorValueChanged?(CGFloat(redSlider.slider.value), CGFloat(greenSlider.slider.value), CGFloat(blueSlider.slider.value))
    }
    
    func setSliderValue(red: Float, green: Float, blue: Float) {
        redSlider.slider.setValue(red, animated: false)
        greenSlider.slider.setValue(green, animated: false)
        blueSlider.slider.setValue(blue, animated: false)
        sliderValueChanged()
    }
}

private class ColorSlider: UIView {
    private(set) lazy var sliderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private(set) lazy var slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 255
        slider.minimumValue = 0
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sliderLabel)
        addSubview(slider)
        sliderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
        }
        slider.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(sliderLabel.snp.right).offset(10)
            $0.right.equalTo(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
