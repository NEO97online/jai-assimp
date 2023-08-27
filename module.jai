// Assimp bindings.

// WARNING: This returns a string view pointing to stack-allocated memory from Assimp.
// We need to either change this, or write another helper to alloc the aiString contents.
to_string :: (ai_str: aiString) -> string {
    s: string = ---;
    s.data = *ai_str.data[0];
    s.count = ai_str.length;

    return s;
}

using aiPostProcessSteps;

#scope_module

size_t :: u64;

#if OS == .WINDOWS {
    #load "windows.jai";
} else {
    #load "unix.jai";
}