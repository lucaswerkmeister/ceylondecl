import ceylon.test {
    test,
    assertEquals
}
import de.lucaswerkmeister.ceylondecl.core {
    CeylonDecl
}
import ceylon.ast.core {
    Node
}
import ceylon.ast.redhat {
    compileDeclaration,
    compileType
}

void do(String code, String description) {
    variable Node? node;
    try {
        node = compileDeclaration(code);
    } catch (AssertionError e) {
        node = compileType(code);
    }
    assertEquals {
        expected = description;
        actual = node?.transform(CeylonDecl());
    };
}

test
shared void baseType()
        => do("String", "String");

test
shared void baseTypeWithArguments()
        => do("Iterable<String>", "Iterable of String");

test
shared void baseTypeWithVariantArguments()
        => do("Iterable<in String, out Nothing>", "Iterable of contravariant String, covariant Nothing");

test
shared void entryType()
        => do("String->Integer", "entry from String to Integer");

test
shared void emptyTupleType()
        => do("[]", "empty tuple");

test
shared void tupleType()
        => do("[Integer,String,Iterable<String>]", "tuple of Integer, String, Iterable of String");

test
shared void sequentialType()
        => do("[Boolean*]", "tuple of zero or more Booleans");

test
shared void sequenceType()
        => do("[Boolean+]", "tuple of one or more Booleans");

test
shared void trailingTupleType()
        => do("[Integer,Integer,Integer*]", "tuple of Integer, Integer, zero or more Integers");

test
shared void iterableType()
        => do("{[Integer]*}", "stream of zero or more tuples of Integer");

test
shared void groupedType()
        => do("{<String->Integer>+}", "stream of one or more entries from String to Integer");

test
shared void arrayType()
        => do("Boolean[]", "sequence of Booleans");

test
shared void optionalType()
        => do("Integer?", "maybe Integer");

test
shared void callableType()
        => do("Integer(Integer,Integer)", "function taking Integer, Integer returning Integer");

test
shared void intersectionType()
        => do("{Persistent&Printable&Identifiable*}", "stream of zero or more Persistents and Printables and Identifiables");

test
shared void unionType()
        => do("{Integer|Float*}", "stream of zero or more Integers or Floats");

test
shared void valueDeclaration()
        => do("String|[Character*] text;", "declare text as String or tuple of zero or more Characters");

test
shared void valueDefinition()
        => do("String|[Character*] text = []", "define text as String or tuple of zero or more Characters");
