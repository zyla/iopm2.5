from __future__ import division, print_function

from setuptools import setup
import io
import os
import re


# Example code to pull version from esptool.py with regex, taken from
# http://python-packaging-user-guide.readthedocs.org/en/latest/single_source_version/
def read(*names, **kwargs):
    with io.open(
            os.path.join(os.path.dirname(__file__), *names),
            encoding=kwargs.get("encoding", "utf8")
    ) as fp:
        return fp.read()


def find_version(*file_paths):
    version_file = read(*file_paths)
    version_match = re.search(r"^__version__ = ['\"]([^'\"]*)['\"]",
                              version_file, re.M)
    if version_match:
        return version_match.group(1)
    raise RuntimeError("Unable to find version string.")


long_description = """
==========
esptool.py
==========
A command line utility to communicate with the ROM bootloader in Espressif ESP8266 WiFi microcontroller.

Allows flashing firmware, reading back firmware, querying chip parameters, etc.

The esptool.py project is hosted on github: https://github.com/espressif/esptool

Installation
------------

esptool can be installed via pip:

  $ pip install --upgrade esptool

Since version 1.3, esptool supports both Python 2.7 and Python 3.4 or newer.

Usage
-----

Please see the `Usage section of the README.md file <https://github.com/espressif/esptool#usage>`_.

You can also get help information by running `esptool.py --help`.

Contributing
------------
Please see the `CONTRIBUTING.md file on github <https://github.com/espressif/esptool/blob/master/CONTRIBUTING.md>`_.
"""

setup(
    name='esptool',
    py_modules=['esptool'],
    version=find_version('esptool.py'),
    description='A utility to communicate with the ROM bootloader in Espressif ESP8266.',
    long_description=long_description,
    url='https://github.com/espressif/esptool',
    author='Fredrik Ahlberg (themadinventor) & Angus Gratton (projectgus)',
    author_email='angus@espressif.com',
    license='GPLv2+',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'Operating System :: POSIX',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: MacOS :: MacOS X',
        'Topic :: Software Development :: Embedded Systems',
        'Environment :: Console',
        'License :: OSI Approved :: GNU General Public License v2 or later (GPLv2+)',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
    ],
    tests_require=[
        'flake8>=3.2.0',
        'flake8-future-import',
    ],
    install_requires=[
        'pyserial>=2.5',
        'pyaes',
        'ecdsa',
    ],
    scripts=[
        'esptool.py',
        'espsecure.py',
        'espefuse.py',
    ],
)
