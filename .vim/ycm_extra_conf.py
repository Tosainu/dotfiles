import ycm_core

CFAMILY_FILETYPE_FLAGS = {
    'c': ['-x', 'c', '-std=c11'],
    'cpp': ['-x', 'c++', '-std=c++20'],
}

CFAMILY_COMMON_FLAGS = [
    '-Wall',
    '-Wextra',
    '-pedantic',
    '-DNDEBUG',
    '-I',
    '.',
]


def Settings(**kwargs):
    language = kwargs['language']
    client_data = kwargs['client_data']
    filetype = client_data.get('&filetype', '')

    if language == 'cfamily':
        return {
            'ls': {
                'fallbackFlags': CFAMILY_FILETYPE_FLAGS.get(filetype, []) + CFAMILY_COMMON_FLAGS,
            }
        }

    return {}
