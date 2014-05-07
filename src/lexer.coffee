{EventEmitter} = require 'events'
_ = require 'lodash'


# Small and experimental regex-powered lexer.
class Lexer extends EventEmitter
  constructor: ->
    @rules = []

  # Create a rule and append it to @rules.
  rule: (name, options) ->
    rule = name

    # Allow some flexibility on inputs.
    if arguments.length > 1
      rule = {name}

      if _.isRegExp(options) or _.isArray options
        options = {regex: options}

      _.extend rule, options

    # Check for basic requirements.
    unless rule.name? and rule.regex?
      throw "Error: Rule '#{rule.name or rule.regex}'
        needs both a name and regex."

    # Register callback if possible.
    @on rule.name, rule.callback if rule.callback?

    # Save references in @rules.
    @rules.push rule
    @rules[name] = rule

    return @

  # Scan the input text and return a list of tokens.
  scan: (text, rules=@rules) ->
    tokens = []

    # Process rules against text and chomp until it's gone.
    while length = text?.length
      for rule in rules
        match = null

        # Try multiple regexes if possible.
        if rule.regex.length
          for regex in rule.regex
            break if match = text.match regex

        if match ?= text.match rule.regex
          # Create a context for callbacks to manipulate.
          context = {rule, match, text, tokens}

          # Add the token to the context.
          context.token =
            type: context.rule.name

            # Shouldn't ever be a list with one item.
            content: if match[2]? then match[1..] else match[1] or match[0]

          # Allow registered callbacks to interfere.
          @emit context.token.type, context
          @emit 'token', context

          # Store a copy of the token unless told not to.
          unless context.rule.ignore is on
            tokens.push context.token

          # Only chomp if allowed and haven't already.
          unless context.rule.chomp is off and length is text.length
            text = text[match[0].length..]

      # Can't keep trying if no rules match.
      if length is text.length
        throw "Error: No rules match the following:\n#{text}"

    return tokens


module.exports = {Lexer}
