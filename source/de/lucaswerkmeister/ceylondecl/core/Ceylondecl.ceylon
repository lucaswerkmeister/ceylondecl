import ceylon.ast.core {
    AnyFunction,
    AnyValue,
    BaseType,
    CallableParameter,
    CallableType,
    DefaultedParameter,
    EntryType,
    GroupedType,
    InModifier,
    IntersectionType,
    IterableType,
    Node,
    OptionalType,
    OutModifier,
    ParameterReference,
    Parameters,
    ScopedKey,
    SequentialType,
    TupleType,
    TypeArgument,
    UnionType,
    WideningTransformer,
    TypeList,
    ValueParameter,
    VariadicParameter,
    VariadicType
}

shared class CeylonDecl() satisfies WideningTransformer<String> {
    
    value plural = ScopedKey<Boolean>(`class CeylonDecl`, "plural");
    
    function isPlural(Node node) => node.get(plural) else false;
    function propagatePlural(Node from, Node to) => if (isPlural(from)) then to.set(plural, true) else null;
    
    shared actual String transformNode(Node that) {
        throw Exception("Can’t process this node type");
    }
    
    shared actual String transformAnyFunction(AnyFunction that) {
        value declare = that.definition exists then "define" else "declare";
        return "``declare`` ``that.name.name`` as function taking ``" then ".join(that.parameterLists*.transform(this))`` returning ``that.type.transform(this)``";
    }
    
    shared actual String transformAnyValue(AnyValue that) {
        value declare = that.definition exists then "define" else "declare";
        return "``declare`` ``that.name.name`` as ``that.type.transform(this)``";
    }
    
    shared actual String transformBaseType(BaseType that) {
        value ownName = that.nameAndArgs.name.name;
        value pluralSuffix = ownName.endsWith("s") then "'" else "s";
        value name = ownName + (isPlural(that) then pluralSuffix else "");
        if (exists args = that.nameAndArgs.typeArguments) {
            return "``name`` of ``", ".join(args.typeArguments*.transform(this))``";
        } else {
            return name;
        }
    }
    
    shared actual String transformCallableParameter(CallableParameter that)
            => "function ``that.name.name`` taking ``" then ".join(that.parameterLists*.transform(this))`` returning ``that.type.transform(this)``";
    
    shared actual String transformCallableType(CallableType that) {
        value funktion = isPlural(that) then "functions" else "function";
        return "``funktion`` taking ``that.argumentTypes.transform(this)`` returning ``that.returnType.transform(this)``";
    }
    
    shared actual String transformDefaultedParameter(DefaultedParameter that)
            => "defaulted ``that.parameter.transform(this)``";
    
    shared actual String transformEntryType(EntryType that) {
        value entry = isPlural(that) then "entries" else "entry";
        return "``entry`` from ``that.key.transform(this)`` to ``that.item.transform(this)``";
    }
    
    shared actual String transformGroupedType(GroupedType that) {
        propagatePlural(that, that.type);
        return that.type.transform(this);
    }
    
    shared actual String transformIntersectionType(IntersectionType that) {
        for (type in that.children) {
            propagatePlural(that, type);
        }
        return " and ".join(that.children*.transform(this));
    }
    
    shared actual String transformIterableType(IterableType that) {
        value stream = isPlural(that) then "streams" else "stream";
        return "``stream`` of ``that.variadicType.transform(this)``";
    }
    
    shared actual String transformOptionalType(OptionalType that) {
        propagatePlural(that, that.definiteType);
        return "maybe ``that.definiteType.transform(this)``";
    }
    
    shared actual String transformParameterReference(ParameterReference that)
            => that.name.name;
    
    shared actual String transformParameters(Parameters that)
            => that.parameters.empty then "no parameters" else ", ".join(that.parameters*.transform(this));
    
    shared actual String transformSequentialType(SequentialType that) {
        value sequence = isPlural(that) then "sequences" else "sequence";
        that.elementType.set(plural, true);
        return "``sequence`` of ``that.elementType.transform(this)``";
    }
    
    shared actual String transformTupleType(TupleType that) {
        value tuple = isPlural(that) then "tuples" else "tuple";
        return that.typeList.children.empty then "empty ``tuple``" else "``tuple`` of ``that.typeList.transform(this)``";
    }
    
    shared actual String transformTypeArgument(TypeArgument that) {
        value variance
                = switch (var = that.variance)
            case (null) ""
            case (is InModifier) "contravariant "
            case (is OutModifier) "covariant ";
        propagatePlural(that, that.type);
        return variance + that.type.transform(this);
    }
    
    shared actual String transformTypeList(TypeList that)
            => ", ".join(that.elements*.transform(this).append(emptyOrSingleton(that.variadic?.transform(this))));
    
    shared actual String transformUnionType(UnionType that) {
        for (type in that.children) {
            propagatePlural(that, type);
        }
        return " or ".join(that.children*.transform(this));
    }
    
    shared actual String transformValueParameter(ValueParameter that)
            => "``that.type.transform(this)`` ``that.name.name``";
    
    shared actual String transformVariadicParameter(VariadicParameter that)
            => "``that.type.transform(this)`` ``that.name.name``";
    
    shared actual String transformVariadicType(VariadicType that) {
        value min = that.isNonempty then "one" else "zero";
        that.elementType.set(plural, true);
        return "``min`` or more ``that.elementType.transform(this)``";
    }
}
