CC=coffee
CFLAGS=

SOURCES=$(wildcard src/*.coffee)
TARGETS=$(patsubst src/%.coffee,lib/reglex/%.js,$(SOURCES))

all: $(TARGETS)

publish: all
	npm publish

lib/reglex/%.js: src/%.coffee
	$(CC) -o $@ $(CFLAGS) -c $<
