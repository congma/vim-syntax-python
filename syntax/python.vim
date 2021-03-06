" Vim syntax file
" Language:	Python
" Maintainer:	Cong Ma <cma@pmo.ac.cn>
" Last Change:	2021 Feb 18
" Credits:	Zvezdan Petkovic <zpetkovic@acm.org>
"		Neil Schemenauer <nas@python.ca>
"		Dmitry Vasiliev
"
"		This version is a major rewrite by Zvezdan Petkovic.
"
"		- introduced highlighting of doctests
"		- updated keywords, built-ins, and exceptions
"		- highlighted string formatting/templating directives
"		- corrected regular expressions for
"
"		  * functions
"		  * decorators
"		  * strings
"		  * escapes
"		  * numbers
"		  * space error
"
"		- corrected synchronization
"		- more highlighting is ON by default, except
"		- space error highlighting is OFF by default
"
" Optional highlighting can be controlled using these variables.
"
"   let python_no_builtin_highlight = 1
"   let python_no_doctest_code_highlight = 1
"   let python_no_doctest_highlight = 1
"   let python_no_exception_highlight = 1
"   let python_no_number_highlight = 1
"   let python_no_string_format_highlight = 1
"   let python_no_string_template_highlight = 1
"   let python_space_error_highlight = 1
"
" All the options above can be switched on together.
"
"   let python_highlight_all = 1
"

" For version 5.x: Clear all syntax items.
" For version 6.x: Quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" We need nocompatible mode in order to continue lines with backslashes.
" Original setting will be restored.
let s:cpo_save = &cpo
set cpo&vim

" Keep Python keywords in alphabetical order inside groups for easy
" comparison with the table in the 'Python Language Reference'
" http://docs.python.org/reference/lexical_analysis.html#keywords.
" Groups are in the order presented in NAMING CONVENTIONS in syntax.txt.
" Exceptions come last at the end of each group (class and def below).
syn keyword pythonStatement	as assert break continue del
syn keyword pythonStatement     global lambda nonlocal pass return with yield
syn keyword pythonStatement	class def nextgroup=pythonFunction skipwhite
syn keyword pythonConditional	elif else if
syn keyword pythonRepeat	for while
syn keyword pythonOperator	and in is not or
syn keyword pythonException	except finally raise try
syn keyword pythonInclude	from import
syn keyword pythonAsync		async await

" Decorators (new in Python 2.4)
" A dot must be allowed because of @MyClass.myfunc decorators.
syn match   pythonDecorator	"@" display contained
syn match   pythonDecoratorName	"@\s*\h\%(\w\|\.\)*" display contains=pythonDecorator
"
" Python 3.5 introduced the use of the same symbol for matrix multiplication:
" https://www.python.org/dev/peps/pep-0465/.  We now have to exclude the
" symbol from highlighting when used in that context.
" Single line multiplication.
syn match   pythonMatrixMultiply
      \ "\%(\w\|[])]\)\s*@"
      \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonFunction,pythonDoctestValue
      \ transparent
" Multiplication continued on the next line after backslash.
syn match   pythonMatrixMultiply
      \ "[^\\]\\\s*\n\%(\s*\.\.\.\s\)\=\s\+@"
      \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonFunction,pythonDoctestValue
      \ transparent
" Multiplication in a parenthesized expression over multiple lines with @ at
" the start of each continued line; very similar to decorators and complex.
syn match   pythonMatrixMultiply
      \ "^\s*\%(\%(>>>\|\.\.\.\)\s\+\)\=\zs\%(\h\|\%(\h\|[[(]\).\{-}\%(\w\|[])]\)\)\s*\n\%(\s*\.\.\.\s\)\=\s\+@\%(.\{-}\n\%(\s*\.\.\.\s\)\=\s\+@\)*"
      \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonFunction,pythonDoctestValue
      \ transparent

" The zero-length non-grouping match before the function name is
" extremely important in pythonFunction.  Without it, everything is
" interpreted as a function inside the contained environment of
" doctests.
" A dot must be allowed because of @MyClass.myfunc decorators.
syn match   pythonFunction
      \ "\%(\%(def\s\|class\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained

syn match   pythonComment	"#.*$" contains=pythonTodo,@Spell
" File header
if !exists("python_no_file_header")
  syn match   pythonRun		"\%^#!.*$"
  syn match   pythonCoding	"\%^.*\%(\n.*\)\?#.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$"
endif
syn keyword pythonTodo		FIXME NOTE NOTES TODO XXX contained

" Triple-quoted strings can contain doctests.
syn region  pythonString
      \ start=+\%(f\|F\|u\|U\)\=\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=pythonEscape,@Spell
syn region  pythonString
      \ start=+\%(f\|F\|u\|U\)\=\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonEscape,pythonSpaceError,pythonDoctest,@Spell
syn region  pythonRawString
      \ start=+\%([rR]\|[rR][fF]\|[fF][rR]\)\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=@Spell
syn region  pythonRawString
      \ start=+\%([rR]\|[rR][fF]\|[fF][rR]\)\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonSpaceError,pythonDoctest,@Spell

" bytes literal
syn region  pythonBytes
      \ start=+[bB]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1" extend
      \ contains=pythonEscape,pythonNonAsciiError
syn region  pythonBytes
      \ start=+[bB]\z('''\|"""\)+ end="\z1" keepend extend
      \ contains=pythonEscape,pythonSpaceError,pythonNonAsciiError
syn region  pythonRawBytes extend
      \ start=+\%([rR][bB]\|[bB][rR]\)\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=pythonNonAsciiError
syn region  pythonRawBytes extend
      \ start=+\%([rR][bB]\|[bB][rR]\)\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonSpaceError,pythonNonAsciiError
syn match   pythonNonAsciiError	display "[^\x00-\x7f]" contained containedin=pythonBytes,pythonRawBytes

syn match   pythonEscape	+\\[abfnrtv'"\\]+ contained display
syn match   pythonEscape	"\\\o\{1,3}" contained display
syn match   pythonEscape	"\\x\x\{2}" contained display
syn match   pythonEscape	"\%(\\u\x\{4}\|\\U\x\{8}\)" contained display
" Python allows case-insensitive Unicode IDs: http://www.unicode.org/charts/
syn match   pythonEscape	"\\N{\a\+\%(\s\a\+\)*}" contained display
syn match   pythonEscape	"\\$"

if exists("python_highlight_all")
  if exists("python_no_builtin_highlight")
    unlet python_no_builtin_highlight
  endif
  if exists("python_no_doctest_code_highlight")
    unlet python_no_doctest_code_highlight
  endif
  if exists("python_no_doctest_highlight")
    unlet python_no_doctest_highlight
  endif
  if exists("python_no_exception_highlight")
    unlet python_no_exception_highlight
  endif
  if exists("python_no_number_highlight")
    unlet python_no_number_highlight
  endif
  if exists("python_no_string_format_highlight")
    unlet python_no_string_format_highlight
  endif
  if exists("python_no_string_template_highlight")
    unlet python_no_string_template_highlight
  endif
  if exists("python_no_file_header")
    unlet python_no_file_header
  endif
  let python_space_error_highlight = 1
endif

" Numeric literals
" http://docs.python.org/reference/lexical_analysis.html#numeric-literals
if !exists("python_no_number_highlight")
  " integer literal
  syn match   pythonNumber	"\<0[oO]\%(_\=\o\)\+\>"
  syn match   pythonNumber	"\<0[xX]\%(_\=\x\)\+\>"
  syn match   pythonNumber	"\<0[bB]\%(_\=[01]\)\+\>"
  syn match   pythonNumber	"\<\%([1-9]\%(_\=\d\)*\|0\+\%(_\=0\)*\)\>"
  " pointfloat (possibly as imaginary literal)
  syn match   pythonNumber	"\%(^\s*\|\W\)\zs\%(\d\%(_\=\d\)*\)\=\.\%(\d\%(_\=\d\)*\)\>"
  syn match   pythonNumber	"\%(^\s*\|\W\)\zs\%(\d\%(_\=\d\)*\)\=\.\%(\d\%(_\=\d\)*\)[jJ]\>"
  syn match   pythonNumber	"\%(^\s*\|\W\)\zs\%(\d\%(_\=\d\)*\)\.\>"
  syn match   pythonNumber	"\%(^\s*\|\W\)\zs\%(\d\%(_\=\d\)*\)\.[jJ]\>"
  " exponentfloat (possibly as imaginary literal)
  syn match   pythonNumber	"\%(^\s*\|\W\)\zs\%(\%(\d\%(_\=\d\)*\)\|\%(\d\%(_\=\d\)*\)\.\|\%(\d\%(_\=\d\)*\)\=\.\%(\d\%(_\=\d\)*\)\)[eE][+-]\=\%(\d\%(_\=\d\)*\)[jJ]\=\>"
  " other imaginary literal (digipart (j | J))
  syn match  pythonNumber	"\<\%(\d\%(_\=\d\)*\)[jJ]\>"
endif

" Group the built-ins in the order in the 'Python Library Reference' for
" easier comparison.
" http://docs.python.org/library/constants.html
" http://docs.python.org/library/functions.html
" http://docs.python.org/library/functions.html#non-essential-built-in-functions
" Python built-in functions are in alphabetical order.
if !exists("python_no_builtin_highlight")
  " built-in constants
  syn keyword pythonBuiltin	False True None
  syn keyword pythonBuiltin	NotImplemented Ellipsis __debug__ 
  " built-in functions
  syn keyword pythonBuiltin	abs all any ascii bin bool breakpoint bytearray bytes callable chr classmethod
  syn keyword pythonBuiltin	compile complex delattr dict dir divmod
  syn keyword pythonBuiltin	enumerate eval exec filter float format
  syn keyword pythonBuiltin	frozenset getattr globals hasattr hash
  syn keyword pythonBuiltin	help hex id input int isinstance
  syn keyword pythonBuiltin	issubclass iter len list locals map max
  syn keyword pythonBuiltin	memoryview min next object oct open ord pow print
  syn keyword pythonBuiltin	property range repr reversed round set
  syn keyword pythonBuiltin	setattr slice sorted staticmethod str
  syn keyword pythonBuiltin	sum super tuple type vars zip __import__
  syn match   pythonAttribute	/\.\h\w*/hs=s+1
	\ contains=ALLBUT,pythonBuiltin,pythonFunction,pythonAsync
	\ transparent
endif

" From the 'Python Library Reference' class hierarchy at the bottom.
" http://docs.python.org/library/exceptions.html
if !exists("python_no_exception_highlight")
  " builtin base exceptions (only used as base classes for other exceptions)
  syn keyword pythonBuiltIn	BaseException Exception
  syn keyword pythonBuiltIn	ArithmeticError BufferError
  syn keyword pythonBuiltIn	LookupError
  " builtin exceptions (actually raised)
  syn keyword pythonExceptions	AssertionError AttributeError
  syn keyword pythonExceptions	EOFError FloatingPointError GeneratorExit
  syn keyword pythonExceptions	ImportError ModuleNotFoundError
  syn keyword pythonExceptions	IndexError KeyError KeyboardInterrupt
  syn keyword pythonExceptions	MemoryError NameError NotImplementedError
  syn keyword pythonExceptions	OSError OverflowError RecursionError
  syn keyword pythonExceptions	ReferenceError
  syn keyword pythonExceptions	RuntimeError StopIteration StopAsyncIteration
  syn keyword pythonExceptions	SyntaxError IndentationError TabError
  syn keyword pythonExceptions	SystemError SystemExit TypeError
  syn keyword pythonExceptions	UnboundLocalError UnicodeError
  syn keyword pythonExceptions	UnicodeDecodeError UnicodeEncodeError
  syn keyword pythonExceptions	UnicodeTranslateError ValueError
  syn keyword pythonExceptions	ZeroDivisionError
  " aliased exceptions
  syn keyword pythonExceptions	IOError WindowsError VMSError 
  " OS exceptions
  syn keyword pythonExceptions	BlockingIOError BrokenPipeError 
  syn keyword pythonExceptions	ChildProcessError ConnectionError
  syn keyword pythonExceptions	ConnectionAbortedError ConnectionRefusedError
  syn keyword pythonExceptions	ConnectionResetError FileExistsError
  syn keyword pythonExceptions	FileNotFoundError InterruptedError
  syn keyword pythonExceptions	IsADirectoryError NotADirectoryError
  syn keyword pythonExceptions	PermissionError ProcessLookupError TimeoutError
  " builtin warnings
  syn keyword pythonExceptions	BytesWarning DeprecationWarning FutureWarning
  syn keyword pythonExceptions	ImportWarning PendingDeprecationWarning
  syn keyword pythonExceptions	ResouceWarning
  syn keyword pythonExceptions	RuntimeWarning SyntaxWarning UnicodeWarning
  syn keyword pythonExceptions	UserWarning Warning
endif

if exists("python_space_error_highlight")
  " trailing whitespace
  syn match   pythonSpaceError	display excludenl "\s\+$"
  " mixed tabs and spaces
  syn match   pythonSpaceError	display " \+\t"
  syn match   pythonSpaceError	display "\t\+ "
endif

" String format
if !exists("python_no_string_format_highlight")
  syn match pythonStrFormatting	"%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrsa%]" contained containedin=pythonString,pythonRawString
  syn match pythonStrFormatting	"%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrsa%]" contained containedin=pythonString,pythonRawString
  syn match pythonStrFormatting "{{\|}}" contained containedin=pythonString,pythonRawString
  syn match pythonStrFormatting	"{\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)\=\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\[\%(\d\+\|[^!:\}]\+\)\]\)*\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonRawString
endif

" String templating
if !exists("python_no_string_template_highlight")
  syn match pythonStrTemplate	"\$\$" contained containedin=pythonString,pythonRawString
  syn match pythonStrTemplate	"\${[a-zA-Z_][a-zA-Z0-9_]*}" contained containedin=pythonString,pythonRawString
  syn match pythonStrTemplate	"\$[a-zA-Z_][a-zA-Z0-9_]*" contained containedin=pythonString,pythonRawString
endif

" Do not spell doctests inside strings.
" Notice that the end of a string, either ''', or """, will end the contained
" doctest too.  Thus, we do *not* need to have it as an end pattern.
if !exists("python_no_doctest_highlight")
  if !exists("python_no_doctest_code_highlight")
    syn region pythonDoctest
	  \ start="^\s*>>>\s" end="^\s*$"
	  \ contained contains=ALLBUT,pythonDoctest,pythonFunction,@Spell
    syn region pythonDoctestValue
	  \ start=+^\s*\%(>>>\s\|\.\.\.\s\|"""\|'''\)\@!\S\++ end="$"
	  \ contained
  else
    syn region pythonDoctest
	  \ start="^\s*>>>" end="^\s*$"
	  \ contained contains=@NoSpell
  endif
endif

" Sync at the beginning of class, function, or method definition.
syn sync match pythonSync grouphere NONE "^\s*\%(def\|class\)\s\+\h\w*\s*("

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default highlight links.  Can be overridden later.
  HiLink pythonStatement	Statement
  HiLink pythonConditional	Conditional
  HiLink pythonRepeat		Repeat
  HiLink pythonOperator		Operator
  HiLink pythonException	Exception
  HiLink pythonInclude		Include
  HiLink pythonAsync		Statement
  HiLink pythonDecorator	Define
  HiLink pythonDecoratorName	Function
  HiLink pythonFunction		Function
  HiLink pythonComment		Comment
  HiLink pythonTodo		Todo
  HiLink pythonString		String
  HiLink pythonRawString	String
  HiLink pythonBytes		String
  HiLink pythonRawBytes		String
  HiLink pythonEscape		Special
  HiLink pythonNonAsciiError	Error
  if !exists("python_no_number_highlight")
    HiLink pythonNumber		Number
  endif
  if !exists("python_no_builtin_highlight")
    HiLink pythonBuiltin	Constant
  endif
  if !exists("python_no_exception_highlight")
    HiLink pythonExceptions	Structure
  endif
  if exists("python_space_error_highlight")
    HiLink pythonSpaceError	Error
  endif
  if !exists("python_no_doctest_highlight")
    HiLink pythonDoctest	Special
    HiLink pythonDoctestValue	Define
  endif
  if !exists("python_no_string_format_highlight")
    HiLink pythonStrFormatting    Special
  endif
  if !exists("python_no_string_template_highlight")
    HiLink pythonStrTemplate      Special
  endif
  if !exists("python_no_file_header")
    HiLink pythonCoding           Special
    HiLink pythonRun              Special
  endif

  delcommand HiLink
endif

let b:current_syntax = "python"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2 ts=8 noet:
