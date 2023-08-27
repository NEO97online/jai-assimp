AT_COMPILE_TIME :: true;

ASSIMP_PATH :: "src/assimp-5.2.5/include";

DECLARATIONS_TO_OMIT :: string.[
    // none yet...
];

#if AT_COMPILE_TIME {
    #run {
        set_build_options_dc(.{do_output=false});
        if !generate_bindings() {
            compiler_set_workspace_status(.FAILED);
        }
    }
} else {
    #import "System";

    main :: () {
        set_working_directory(path_strip_filename(get_path_of_running_executable()));
        if !generate_bindings() {
            exit(1);
        }
    }
}

generate_bindings :: () -> bool {
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        #if OS == .WINDOWS {
            array_add(*libpaths, "windows");
            output_filename = "windows.jai";
        } else #if OS == .LINUX {
            array_add(*libpaths, "linux");
            output_filename = "linux.jai";
        } else #if OS == .MACOS {
            array_add(*libpaths, "macos");
            output_filename = "unix.jai";
        } else {
            assert(false);
        }

        array_add(*libnames, "assimp-vc143-mt");
        array_add(*include_paths, ASSIMP_PATH);
        array_add(*source_files, tprint("%/assimp/cimport.h", ASSIMP_PATH));
        array_add(*source_files, tprint("%/assimp/scene.h", ASSIMP_PATH));
        array_add(*source_files, tprint("%/assimp/postprocess.h", ASSIMP_PATH));
    }

    return generate_bindings(opts, output_filename);
}

#import "Basic";
#import "Bindings_Generator";
#import "Compiler";
#import "File";
#import "Hash_Table";
#import "String";

#if OS == .WINDOWS  assimp :: #library "windows/assimp-vc143-mt";
#if OS == .LINUX    assimp :: #library "linux/libassimp.so";
#if OS == .MACOS    assimp :: #library "macos/libassimp.dylib";
