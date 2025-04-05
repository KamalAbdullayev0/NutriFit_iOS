//
//  AgeController.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 31.03.25.
//
import UIKit

class AgeViewController: UIViewController {
    private let viewModel: AgeViewModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's your age?"
        label.font = Resources.AppFont.bold.withSize(30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var agePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    private lazy var continueButton = CustomButtonContinue { [weak self] in
                self?.viewModel.continueButtonTapped()
    }
    
    init(viewModel: AgeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        selectInitialAge()
        agePickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        customButtonBack()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(agePickerView)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            agePickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            agePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            agePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            agePickerView.heightAnchor.constraint(equalToConstant: 800),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            continueButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 220)
            
        ])
    }
    
    
    private func selectInitialAge() {
        if let initialIndex = viewModel.ageRange.firstIndex(of: viewModel.selectedAge) {
            agePickerView.selectRow(initialIndex, inComponent: 0, animated: false)
        }
    }
}

extension AgeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let age = viewModel.ageValue(at: row)
        let isSelected = (age == viewModel.selectedAge)
        let cell: PickerRowView
        if let reusedView = view as? PickerRowView {
            cell = reusedView
        } else {
            cell = PickerRowView()
        }
        cell.label.text = "\(age) years old"
        cell.label.font = UIFont.systemFont(
            ofSize: isSelected ? 34 : 28,
            weight: isSelected ? .bold : .regular
        )
        cell.label.textColor = isSelected ? .black : .systemGray
        
        return cell
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedAge = viewModel.ageValue(at: row)
        viewModel.updateSelectedAge(selectedAge)
        pickerView.reloadComponent(component)
        pickerView.selectRow(row, inComponent: component, animated: true)
    }
}
class PickerRowView: UIView {
    let label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
