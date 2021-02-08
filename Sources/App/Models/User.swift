import Vapor
import Fluent

final class User: Model, Content {
    
    static let schema = "users"
    
    @ID(custom: "id", generatedBy: .user) var id: String?
    @Field(key: "name") var name: String
    
    init() {}
    
    init(id: String?, name: String) {
        self.id = id
        self.name = name
    }
}
