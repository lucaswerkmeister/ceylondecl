import ceylon.ast.core {
    BaseType,
    EntryType,
    InModifier,
    Node,
    OutModifier,
    TupleType,
    TypeArgument,
    WideningTransformer,
    TypeList
}

shared class CeylonDecl() satisfies WideningTransformer<String> {
    
    shared actual String transformNode(Node that) {
        throw Exception("Can’t process this node type");
    }
    
    shared actual String transformBaseType(BaseType that) {
        if (exists args = that.nameAndArgs.typeArguments) {
            return "``that.nameAndArgs.name.name`` of ``", ".join(args.typeArguments*.transform(this))``";
        } else {
            return that.nameAndArgs.name.name;
        }
    }
    
    shared actual String transformEntryType(EntryType that)
            => "entry from ``that.key.transform(this)`` to ``that.item.transform(this)``";
    
    shared actual String transformTupleType(TupleType that)
            => that.typeList.elements.empty then "empty tuple" else "tuple of ``that.typeList.transform(this)``";
    
    shared actual String transformTypeArgument(TypeArgument that) {
        value variance
                = switch (var = that.variance)
            case (null) ""
            case (is InModifier) "contravariant "
            case (is OutModifier) "covariant ";
        return variance + that.type.transform(this);
    }
    
    shared actual String transformTypeList(TypeList that)
            => ", ".join(that.elements*.transform(this));
}
