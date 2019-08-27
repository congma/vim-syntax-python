Python syntax highlighting script for Vim
=========================================

About
-----

This is a fork of Vim 7.4's Python syntax file originally maintained by Neil
Schemenauer.  The original contributors include Dmitry Vasiliev, Neil
Schemenauer and Zvezdan Petkovic.  Some useful features from Dmitry Vasiliev's
`syntax/python.vim` are added back, while enhancements are added and bugs are
fixed whenever found.

The syntax file has been cleaned-up for Python 3.x. Syntaxes and highlights
specific to Python 2 have been removed.

Features
--------

* Added back highlighting for magic comments: source code encoding and `#!`
  (executable) strings.
* Added back optional highlighting for `%`-formatting inside strings.
* Non-ASCII characters are highlighted as error in raw-bytes literals
  (e.g. in `rb"..."`).

Bugfixes
--------

* Python builtins are correctly isolated, so things like the word `compile` in
  `re.compile()` are no longer incorrectly highlighted as builtin.

Installation
------------

Simply drop the `syntax/python.vim` file in your `$HOME/.vim/syntax/` runtime
directory.

Script options
--------------

There are two commands to enable or disable an option:

* `let OPTION_NAME = 1`  
  Enable option.
* `let OPTION_NAME = 0`  
  Disable option.

For example, to enable all syntax highlighting features you can place the
following command in your `~/.vimrc` script:  
```viml
let python_highlight_all = 1
```

Options used by the script
--------------------------

* `python_no_builtin_highlight`  
  Do not highlight builtin objects.
* `python_no_exception_highlight`  
  Do not highlight standard exceptions.
* `python_no_string_format_highlight`  
  Do not highlight `%` string formatting.
* `python_no_string_template_highlight`  
  Do not highlight syntax of `string.Template`.
* `python_no_number_highlight`  
  Do not highlight numbers.
* `python_no_doctest_highlight`  
  Do not highlight doc-tests.
* `python_no_doctest_code_highlight`  
  Do not highlight doc-test code.
* `python_no_file_header`  
  Do not highlight shebang or coding comment in file header as special.
* `python_space_error_highlight`  
  Highlight whitespacing errors (*OFF* by default).
* `python_highlight_all`  
  Enable all the highlights.
