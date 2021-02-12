import Vapor
import Fluent

func routes(_ app: Application) throws {
    
    var auth = Auth(applicationId: "APP_ID")
    
    app.post("auth") { req -> EventLoopFuture<UserAuth.Response> in
        let authBody = try req.content.decode(AuthBody.self)
        
        return User.query(on: req.db)
            .filter(\.$name == authBody.name)
            .first()
            .flatMap { user -> EventLoopFuture<UserAuth.Response> in
                if let user = user {
                    let userAuthResponse = UserAuth.Response(
                        name: user.name,
                        jwt: auth.makeJwt(sub: user.name, acl: JwtClaim.defaultPaths))
                    return req.eventLoop.makeSucceededFuture(userAuthResponse)
                } else {
                    return req.client.post(URI(scheme: "https", host: "api.nexmo.com", path: "v0.1/users")) { req in
                        req.headers.add(name: .authorization, value: "Bearer \(auth.adminJWT)")
                        try req.content.encode(UserAuth.Body(name: authBody.name), as: .json)
                    }.flatMap { response -> EventLoopFuture<UserAuth.Response> in
                        let responseBody = try! response.content.decode(IDResponse.self)
                        let user = User(id: responseBody.id, name: authBody.name)
                        let userAuthResponse = UserAuth.Response(
                            name: user.name,
                            jwt: auth.makeJwt(sub: user.name, acl: JwtClaim.defaultPaths))
                        return user.save(on: req.db).map { userAuthResponse }
                    }
                }
            }
    }
    
    app.get("rooms") { req -> EventLoopFuture<[Conversation.Response.Conv]> in
        return req.client.get(URI(scheme: "https", host: "api.nexmo.com", path: "v0.2/conversations")) { req in
            req.headers.add(name: .authorization, value: "Bearer \(auth.adminJWT)")
        }.map { response -> [Conversation.Response.Conv] in
            let responseBody = try! response.content.decode(Conversation.Response.self)
            return responseBody.embedded.data.conversations
        }
    }
    
    app.post("rooms") { req -> EventLoopFuture<IDResponse> in
        let conversationBody = try req.content.decode(Conversation.Body.self)
        return req.client.post(URI(scheme: "https", host: "api.nexmo.com", path: "v0.1/conversations")) { req in
            req.headers.add(name: .authorization, value: "Bearer \(auth.adminJWT)")
            try req.content.encode(conversationBody, as: .json)
        }.map { response -> IDResponse in
            let responseBody = try! response.content.decode(IDResponse.self)
            return responseBody
        }
    }
}
