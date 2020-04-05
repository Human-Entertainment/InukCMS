import Fluent

final class Settings: Model {
    static var schema: String = "preferences"
    
    @ID(key:"id")
    var id: UUID?
    
    @Field(key: "title")
    var title: String
}
