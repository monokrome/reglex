Events = Backbone?.Events or require('backbone').Events
_ = _ or require 'lodash'


#
# reglex.Lexer
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

  # 
  # Scan the input text and return a list of tokens.
  #
  scan: (text, rules) ->
    rules ?= @rules
    tokens = []

    # Process rules against text until it's chomped gone.
    while length = text?.length
      for rule in rules
        match = null

        # Try multiple regexes for this rule.
        if rule.regex.length
          for regex in rule.regex
            break if match = text.match rule.regex

        if match ?= text.match rule.regex
          # Content shouldn't ever be a list with one item.
          content = if match[2]? then match[1..] else match[1] or match[0]

          # Create a context and add match and content to it.
          context = _.extend _.clone(rule), {match, content}

          # Allow registered callbacks to interfere.
          @trigger context.name, {context, text, tokens}

          unless context.ignore is on
            tokens.push
              type: context.name
              content: context.content

          # Only chomp if we are allowed and haven't already.
          unless context.chomp is off or length isnt text.length
            text = text[match[0].length..]

      # Can't keep trying if no rules match.
      if length is text.length
        throw "Error: No rules match the following:\n#{text}"

    return tokens


module?.exports = {
  Lexer
}
