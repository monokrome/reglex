{Lexer} = require './lexer'


symbols = [
  ['square-open', '[']
  ['square-close', ']']
  ['paren-open', '(']
  ['paren-close', ')']
  ['curly-open', '{']
  ['curly-close', '}']
  ['pipe', '|']
  ['question-mark', '?']
  ['colon', ':']
  ['comma', ',']
  ['period', '.']
  ['dollar', '$']
  ['at-sign', '@']
]


common =
  word: /^[a-zA-Z]+/
  identifier: /^[a-zA-Z][\w\-\.]+/
  sentence: /^\w+.+\./
  paragraph: /\w+.+\.\n\n/
  line: /\n/
  number: /^\d+/ 
  integer: /^\d+/
  float: /^\d+\.\d+/
  call: /^\w+\((.*)\)/
  email: /^\w+\@\w+\.\w+/

  symbol:
    regex: /^[^\w\s\d]{1}/
    callback: (context) ->

  comment:
    ignore: on
    regex: [
      /^\#{3}\s*([\s\S]*?)\s*\#{3}/
      /^\#\s*(.*)/
    ]

  garbage:
    regex: /^./
    ignore: on

  whitespace:
    regex: /^\s+/
    ignore: on

  # TODO Grouping
  group:
    regex: [
      /^\(([\s\S]+?)\)/
      /^\[([\s\S]+?)\]/
      /^\{([\s\S]+?)\}/
    ]
    callback: ->

  string:
    regex: [
      /^".*?[^\\]"/
      /^'.*?[^\\]'/
    ]


lex = (text, args) ->
  s = new Lexer 
  s.rule arg, rules[arg] for arg in args
  s.scan text


module.exports = {
  common
  lex
}
