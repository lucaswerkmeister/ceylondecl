import ceylon.ast.core {
    BaseType,
    Node,
    WideningTransformer
}

shared class CeylonDecl() satisfies WideningTransformer<String> {
    
    shared actual String transformNode(Node that) {
        throw Exception("Can’t process this node type");
    }
    
    shared actual String transformBaseType(BaseType that) {
        return that.nameAndArgs.name.name;
    }
}
