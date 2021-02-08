import Vapor
import SwiftJWT

struct Auth {
    let applicationId: String
    
    lazy var adminJWT: String = {
        return makeJwt()
    }()
    
    let jwtSigner: JWTSigner = {
        let privateKeyPath = URL(fileURLWithPath: "Sources/App/private.key")
        let privateKey: Data = try! Data(contentsOf: privateKeyPath, options: .alwaysMapped)
        return JWTSigner.rs256(privateKey: privateKey)
    }()
    
    init(applicationId: String) {
        self.applicationId = applicationId
    }
    
    func makeJwt(sub: String? = nil, acl: CapiJwt.Paths? = nil) -> String {
        let iat = Date().timeIntervalSince1970.rounded()
        let exp = iat.advanced(by: 21600.0)
        let claims = CapiJwt(application_id: applicationId, iat: iat, jti: UUID(), exp: exp, sub: sub, acl: acl)
        var jwt = JWT(claims: claims)
        return try! jwt.sign(using: jwtSigner)
    }
}

struct CapiJwt: Claims {
    typealias Paths = [String: [String: [String: String]]]
    
    let application_id: String
    let iat: TimeInterval
    let jti: UUID
    let exp: TimeInterval
    let sub: String?
    let acl: Paths?
    
    static let defaultPaths: Paths = ["paths":
                                        [
                                            #"/*/users/**"#: [:],
                                            #"/*/conversations/**"#: [:],
                                            #"/*/sessions/**"#: [:],
                                            #"/*/devices/**"#: [:],
                                            #"/*/image/**"#: [:],
                                            #"/*/media/**"#: [:],
                                            #"/*/applications/**"#: [:],
                                            #"/*/push/**"#: [:],
                                            #"/*/knocking/**"#: [:],
                                            #"/*/legs/**"#: [:]
                                        ]
                                     ]
}


