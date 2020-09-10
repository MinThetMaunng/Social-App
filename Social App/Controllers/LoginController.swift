//
//  LoginController.swift
//  Social App
//
//  Created by Min Thet Maung on 09/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class LoginController: LBTAFormController {
    
    // MARK: - UI Elements
    let logoImageView = UIImageView(image: UIImage(named: "startup"), contentMode: .scaleAspectFit)
    let logoLabel = UILabel(text: "FullStack Social", font: .systemFont(ofSize: 32, weight: .heavy), textColor: .black, numberOfLines: 0)
    
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress)
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25)
    lazy var loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .black, target: self, action: #selector(handleLogin))
    let errorLabel = UILabel(text: "Your login crenditals are not correct. Please try again.", font: .boldSystemFont(ofSize: 18), textColor: .red, textAlignment: .center, numberOfLines: 0)
    lazy var goToRegisterButton = UIButton(title: "Don't have account? Go to register", titleColor: .black, font: .systemFont(ofSize: 16), target: self, action: #selector(goToRegister))
    
    
    @objc private func handleLogin() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Logging in"
        hud.show(in: view)
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        errorLabel.isHidden = true
        
        let url = "\(baseUrl)/users/login/"
        let params = ["email": email, "password": password]
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding())
            .validate(statusCode: 200..<300)
            .responseData { (resp) in
            hud.dismiss()
            
                if let _ = resp.error {
                    self.errorLabel.isHidden = false
                    return
                }
                
                guard let data = resp.data else { return }
                do {
                    let loginResp = try JSONDecoder().decode(LoginResponse.self, from: data)
                    guard let token = loginResp.data?.token else {
                        fatalError("Cannot save token into keychain!")
                    }
                    AuthService.shared.jwtToken = token
                } catch(let err) {
                    fatalError("Error in log in response decoding : \(err.localizedDescription)")
                }
                self.dismiss(animated: true)
        }
    }
    
    @objc private func goToRegister() {
        let controller = RegisterController(alignment: .center)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 25
        navigationController?.navigationBar.isHidden = true
        errorLabel.isHidden = true
        
        let formView = UIView()
        formView.stack(
            formView.stack(formView.hstack(logoImageView.withSize(.init(width: 80, height: 80)), logoLabel.withWidth(160), spacing: 16, alignment: .center).padLeft(12).padRight(12), alignment: .center),
            UIView().withHeight(12),
            emailTextField.withHeight(50),
            passwordTextField.withHeight(50),
            loginButton.withHeight(50),
            errorLabel,
            goToRegisterButton,
            UIView().withHeight(80),
            spacing: 16).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        formContainerStackView.padBottom(-24)
        formContainerStackView.addArrangedSubview(formView)
    }
    

}
