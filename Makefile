CC = coffee
CFLAGS =

dist_root = lib/

reglex_dist_root = $(dist_root)reglex/
reglex_sources_root = src/

reglex_sources = $(wildcard $(reglex_sources_root)*.coffee)
reglex_targets = $(patsubst $(reglex_sources_root)%.coffee,$(reglex_dist_root)%.js,$(reglex_sources))

all: $(reglex_targets)

publish: all
	npm publish

$(reglex_dist_root)%.js: $(reglex_sources_root)%.coffee
	$(CC) -o $(dir $@) $(CFLAGS) -c $<

clean:
	rm -rf $(dist_root)

.PHONY: clean all

