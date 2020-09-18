//
//  RegisterController.swift
//  Social App
//
//  Created by Min Thet Maung on 10/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class RegisterController: LBTAFormController {
    
    
    // MARK: - UI Elements
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "startup"), contentMode: .scaleAspectFit)
    let logoLabel = UILabel(text: "FullStack Social", font: .systemFont(ofSize: 32, weight: .heavy), textColor: .black, numberOfLines: 0)
    let firstNameTextField = IndentedTextField(placeholder: "First Name", padding: 24, cornerRadius: 25)
    let middleNameTextField = IndentedTextField(placeholder: "Middle Name", padding: 24, cornerRadius: 25)
    let lastNameTextField = IndentedTextField(placeholder: "Last Name", padding: 24, cornerRadius: 25)
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25)
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25, isSecureTextEntry: true)
    lazy var signupButton = UIButton(title: "Sign Up", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: .black, target: self, action: #selector(handleSignup))
    
    let errorLabel = UILabel(text: "Something went wrong during sign up, please try again later.", font: .systemFont(ofSize: 14), textColor: .red, textAlignment: .center, numberOfLines: 0)
    lazy var goToLoginButton = UIButton(title: "Go back to login.", titleColor: .black, font: .systemFont(ofSize: 16), target: self, action: #selector(goToLogin))
    
    @objc private func handleSignup() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registering"
        hud.show(in: view)
        
        guard let firstName = firstNameTextField.text,
            firstName.count > 0,
            let middleName = middleNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            email.count > 0,
            let password = passwordTextField.text,
            password.count > 0
            else { return }
        
        let params = [
            "firstName": firstName,
            "middleName": middleName,
            "lastName": lastName,
            "email": email,
            "password": password
        ]
        
        AuthService.shared.sendSignUpRequest(parameters: params) { (result) in
            
            hud.dismiss()
            
            switch result {
            case .failure(let err):
                print("Error in sign up : \(err.localizedDescription)")
                self.errorLabel.isHidden = false
                
            case .success(let resp):
                guard let user = resp.data,
                      let token = user.token,
                      let fullName = user.fullName
                else { return }
                AuthService.shared.login(userId: user._id, token: token, fullName: fullName)
                self.dismiss(animated: true)
            }
        }
        
    }
    
    @objc private func goToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSignup()
        return true
    }
    
    private func setupConstraints() {
        let formView = UIView()
        formView.stack(
            formView.stack(formView.hstack(logoImageView.withSize(.init(width: 80, height: 80)), logoLabel.withWidth(160), spacing: 16, alignment: .center).padLeft(12).padRight(12), alignment: .center),
            UIView().withHeight(12),
            firstNameTextField.withHeight(50),
            middleNameTextField.withHeight(50),
            lastNameTextField.withHeight(50),
            emailTextField.withHeight(50),
            passwordTextField.withHeight(50),
            errorLabel,
            signupButton.withHeight(50),
            goToLoginButton,
            UIView().withHeight(80),
            spacing: 16).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        formContainerStackView.addArrangedSubview(formView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        emailTextField.autocapitalizationType = .none
        [firstNameTextField, middleNameTextField, lastNameTextField, emailTextField, passwordTextField].forEach{
            $0.autocorrectionType = .no
            $0.backgroundColor = .white
            
        }
        signupButton.layer.cornerRadius = 25
        
        view.backgroundColor = .init(white: 0.92, alpha: 1)
        
        setupConstraints()
    }
}
