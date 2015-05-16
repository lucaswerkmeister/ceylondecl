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
