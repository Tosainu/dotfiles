import os.path as p
import sys

database = None

extra_flags = [
    '-Wall',
    '-Wextra',
    '-pedantic',
    '-DNDEBUG',
    '-I',
    '.',
]

filetype_flags = {
    'c': ['-x', 'c', '-std=c11'],
    'cpp': ['-x', 'c++', '-std=c++17'],
}

# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
compilation_database_folder = 'build/'


def IsHeaderFile(filename):
    extension = p.splitext(filename)[1]
    return extension in ['.h', '.hxx', '.hpp', '.hh']


def FindCorrespondingSourceFile(filename):
    if IsHeaderFile(filename):
        basename = p.splitext(filename)[0]
        for extension in ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']:
            replacement_file = basename + extension
            if p.exists(replacement_file):
                return replacement_file
    return filename


def Settings(**kwargs):
    import ycm_core

    language = kwargs['language']
    client_data = kwargs['client_data']
    filetype = client_data.get('&filetype', '')

    global database
    if database is None and p.exists(compilation_database_folder):
        database = ycm_core.CompilationDatabase(compilation_database_folder)

    if language == 'cfamily':
        filename = FindCorrespondingSourceFile(kwargs['filename'])

        if not database:
            return {
                'flags': filetype_flags.get(filetype, []) + extra_flags,
                'include_paths_relative_to_dir': p.dirname(p.abspath(__file__)),
                'override_filename': filename
            }

        compilation_info = database.GetCompilationInfoForFile(filename)
        if not compilation_info.compiler_flags_:
            return {}

        return {
            'flags':
                list(compilation_info.compiler_flags_),
            'include_paths_relative_to_dir':
                compilation_info.compiler_working_dir_,
            'override_filename':
                filename
        }

    return {}
