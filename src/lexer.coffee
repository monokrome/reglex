Events = Backbone?.Events or require('backbone').Events
_ = _ or require 'lodash'


#
# Lexer
#
# Small and experimental regex-powered lexer.
# 
class Lexer
  constructor: ->
    _.extend @, Events

    @rules = []

  #
  # Create a rule and append it to @rules.
  # 
  rule: (name, options) ->
    rule = name

    if arguments.length > 1
      rule = {name}

      # TODO String regex support
      if _.isRegExp(options) or _.isArray options
        options = {regex: options}

      _.extend rule, options

    unless rule.name? and (rule.regex? or rule.callback?)
      throw "Error: Rule needs a name, regex and/or callback."

    @rules.push rule

  # 
  # Scan the input text and return a list of tokens.
  #
  scan: (text, rules) ->
    rules ?= @rules
    tokens = []

    while text?.length
      length = text.length

      for rule in rules
        if match = text.match rule.regex
          text = text[match[0].length..]

          unless rule.ignore
            tokens.push
              type: rule.name
              content: match[0]

      if length is text.length
        throw "Error: No rules match the following:\n#{text[..89]}..."

    return tokens


module?.exports = {
  Lexer
}
