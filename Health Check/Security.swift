//
//  Security.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/08.
//

import Foundation
import LocalAuthentication

class Security {
    func biometricsAuth(res: @escaping(Bool)->()) {
        let context = LAContext()
        var error: NSError?
        let description: String = "プロフィールの表示"

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: description, reply: {success, evaluateError in
                if (success) {
                    res(true)
                } else {
                    res(false)
                }
            })
        } else {
            let errorDescription = error?.userInfo["NSLocalizedDescription"] ?? ""
            print(errorDescription)
        }
    }
}
