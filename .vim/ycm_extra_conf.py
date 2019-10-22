from itertools import chain, repeat
from subprocess import Popen, PIPE
import os.path as p
import re
import ycm_core

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

if p.exists(compilation_database_folder):
    database = ycm_core.CompilationDatabase(compilation_database_folder)
else:
    database = None


def GetSearchList(filetype):
    p = Popen(['clang', '-E'] + filetype_flags[filetype] + ['-', '-v'],
              stdout=PIPE,
              stderr=PIPE)
    _, stderr = p.communicate()
    search_list = re.search(
        '#include <\.\.\.> search starts here:\n(.+)\nEnd of search list',
        stderr.decode(), re.DOTALL)
    return [s.strip() for s in search_list.group(1).splitlines()]


def GetDefaultFlags(filetype):
    if filetype in filetype_flags:
        return filetype_flags[filetype] + list(
            chain.from_iterable(
                zip(repeat('-isystem'), GetSearchList(filetype))))
    return []


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
    language = kwargs['language']
    client_data = kwargs['client_data']
    filetype = client_data.get('&filetype', '')

    if language == 'cfamily':
        filename = FindCorrespondingSourceFile(kwargs['filename'])

        default_flags = GetDefaultFlags(filetype)

        if not database:
            return {
                'flags': default_flags + extra_flags,
                'include_paths_relative_to_dir': p.dirname(p.abspath(__file__)),
                'override_filename': filename
            }

        compilation_info = database.GetCompilationInfoForFile(filename)
        if not compilation_info.compiler_flags_:
            return {}

        return {
            'flags': default_flags + list(compilation_info.compiler_flags_),
            'include_paths_relative_to_dir': compilation_info.compiler_working_dir_,
            'override_filename': filename
        }

    return {}
