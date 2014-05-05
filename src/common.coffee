{Lexer} = require './lexer'


commonRules =
  word: /^[a-zA-Z]+/
  sentence: /^\w+.+\./
  paragraph: /\w+.+\.\n\n/
  line: /\n/
  number: /^\d+/ 
  integer: /^\d+/
  float: /^\d+\.\d+/
  symbol: /^[^\w\s\d]{1}/
  call: /^\w+\((.*)\)/
  email: /^\w+\@\w+\.\w+/

  garbage:
    regex: /^./
    ignore: on

  whitespace:
    regex: /^\s+/
    ignore: on

  # TODO Grouping, callback, and array regex
  #group:
  #  regex: [
  #    /^\(([\s\S]+?)\)/
  #    /^\[([\s\S]+?)\]/
  #    /^\{([\s\S]+?)\}/
  #  ]
  #  callback: ->

  #string:
  #  regex: [
  #    /^".*?[^\\]"/
  #    /^'.*?[^\\]'/
  #  ]


scan = (text, args) ->
  s = new Lexer 
  s.rule arg, commonRules[arg] for arg in args
  s.scan text


module.exports = {
  commonRules
  scan
}
