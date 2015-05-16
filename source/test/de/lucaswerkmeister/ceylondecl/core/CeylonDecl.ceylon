import ceylon.test {
    test,
    assertEquals
}
import de.lucaswerkmeister.ceylondecl.core {
    CeylonDecl
}
import ceylon.ast.redhat {
    compileType
}

void do(String code, String description) {
    assertEquals {
        expected = description;
        actual = compileType(code)?.transform(CeylonDecl());
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
        => do("Iterable<in String, out Nothing>", "Iterable of contravariant String and covariant Nothing");

test
shared void entryType()
        => do("String->Integer", "entry from String to Integer");

test
shared void emptyTupleType()
        => do("[]", "empty tuple");

test
shared void tupleType()
        => do("[Integer,String,Iterable<String>]", "tuple of Integer, String and Iterable of String");

test
shared void sequentialType()
        => do("[Boolean*]", "tuple of zero or more Booleans");

test
shared void sequenceType()
        => do("[Boolean+]", "tuple of one or more Booleans");

test
shared void trailingTupleType()
        => do("[Integer,Integer,Integer*]", "tuple of Integer, Integer and zero or more Integers");

test
shared void iterableType()
        => do("{[Integer]*}", "stream of zero or more tuples of Integer");
