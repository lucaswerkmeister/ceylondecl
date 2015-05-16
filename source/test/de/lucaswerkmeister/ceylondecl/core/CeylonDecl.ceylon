import ceylon.test {
    test,
    assertEquals
}
import de.lucaswerkmeister.ceylondecl.core {
    CeylonDecl
}
import ceylon.ast.redhat {
    compileBaseType
}

void do(String code, String description) {
    assertEquals {
        expected = description;
        actual = compileBaseType(code)?.transform(CeylonDecl());
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
