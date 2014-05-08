{Lexer} = require './lexer'


symbols = {
  '~': 'tilde'
  '`': 'backtick'
  '!': 'exclamation'
  '@': 'at'
  '#': 'pound'
  '$': 'dollar'
  '%': 'percent'
  '^': 'carat'
  '&': 'ampersand'
  '*': 'asterisk'
  '(': 'paren-open'
  ')': 'paren-close'
  '-': 'hyphen'
  '_': 'underscore'
  '=': 'equals'
  '[': 'square-open'
  ']': 'square-close'
  '{': 'curly-open'
  '}': 'curly-close'
  '\\': 'backslash'
  '|': 'pipe'
  ':': 'colon'
  ';': 'semicolon'
  '\'': 'single-quote'
  '"': 'double-quote'
  ',': 'comma'
  '.': 'period'
  '<': 'less'
  '>': 'greater'
  '/': 'slash'
  '?': 'question-mark'
}


common =
  word:
    name: 'word'
    regex: /^[a-zA-Z]+/

  whitespace:
    name: 'whitespace'
    regex:  /^\s+/

  identifier:
    name: 'identifier'
    regex:  /^[a-zA-Z][\w\-\.]*/

  sentence:
    name: 'sentence'
    regex:  /^[\w \-\'\"]+\./

  paragraph:
    name: 'paragraph'
    regex:  /^\w+.+\.\n\n/

  line:
    name: 'line'
    regex:  /^\n/

  number:
    name: 'number'
    regex:  /^\d+(?=\.\d+)?/ 

  integer:
    name: 'integer'
    regex:  /^\d+/

  float:
    name: 'float'
    regex:  /^\d+\.\d+/

  call:
    name: 'call'
    regex:  /^\w+\((.*)\)/

  email:
    name: 'email'
    regex:  /^\w+\@\w+\.\w+/

  unknown:
    name: 'unknown'
    regex:  /^[\s\S]/

  comment:
    name: 'comment'
    regex: [
      /^\#{3}\s*([\s\S]*?)\s*\#{3}/
      /^\#\s*(.*)/
    ]

  symbol:
    name: 'symbol'
    regex: /^[^\w\s\d]/
    callback: ({token, tokens, rule}) ->
      if symbol = symbols[token[1]]
        tokens.push [symbol, token[1]]
        rule.ignore = on

  # TODO Grouping
  group:
    name: 'group'
    regex: [
      /^\(([\s\S]+?)\)/
      /^\[([\s\S]+?)\]/
      /^\{([\s\S]+?)\}/
    ]

  string:
    name: 'string'
    regex: [
      /^".*?[^\\]"/
      /^'.*?[^\\]'/
    ]


lex = (text, names=[]) ->
  s = new Lexer 

  s.rule common[name] for name in names

  return s.scan text


module.exports = {
  common
  lex
}
