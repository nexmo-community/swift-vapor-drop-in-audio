import Vapor

struct AuthBody: Content {
    let name: String
}

struct IDResponse: Content {
    let id: String
}

struct UserAuth: Content {
    struct Body: Content {
        let name: String
        let displayName: String
        let imageURL: String
        
        init(name: String) {
            self.name = name
            self.displayName = name
            self.imageURL = "https://example.com/image.png"
        }
        
        enum CodingKeys: String, CodingKey {
            case name
            case displayName = "display_name"
            case imageURL = "image_url"
        }
    }
    
    struct Response: Content {
        let name: String
        let jwt: String
    }
}

struct Conversation: Content {
    struct Body: Content {
        let name: String = UUID().uuidString
        let displayName: String
        let imageURL: String = "https://example.com/image.png"
        let properties: [String: Int] = ["ttl": 300]
        
        enum CodingKeys: String, CodingKey {
            case name, properties
            case displayName = "display_name"
            case imageURL = "image_url"
        }
    }
    
    struct Response: Content {
        let embedded: Embedded
        
        enum CodingKeys: String, CodingKey {
            case embedded = "_embedded"
        }
        
        struct Embedded: Content {
            let data: Conversation.Response.Data
        }
        
        struct Data: Content {
            let conversations: [Conv]
        }
        
        struct Conv: Content {
            let id: String
            let displayName: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case displayName = "display_name"
            }
        }
    }
}
