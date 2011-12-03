#!/usr/bin/make -f
# utility commands for package maintainers

VERSIONFROM:=$(shell sed -n 's,.*_VERSION \+from \+\([^ ]\+\).*,\1,p' rockspec.in)
VERSION:=$(shell sed -n "s,.*_VERSION='\([^']*\)'.*,\1,p" $(VERSIONFROM))-1
NAME=$(shell lua -e 'dofile"rockspec.in"; print(package)')

dist :
	rm -fr tmp/$(NAME)-$(VERSION) tmp/$(NAME)-$(VERSION).zip
	for x in `cat MANIFEST`; do install -D $$x tmp/$(NAME)-$(VERSION)/$$x || exit; done
	sed 's,$$(_VERSION),$(VERSION),g' tmp/$(NAME)-$(VERSION)/rockspec.in > tmp/$(NAME)-$(VERSION)/$(NAME)-$(VERSION).rockspec
	cd tmp && zip -r $(NAME)-$(VERSION).zip $(NAME)-$(VERSION)

install : dist
	cd tmp/$(NAME)-$(VERSION) && luarocks make

test :
	@if [ -e test.lua ]; then lua test.lua; fi
	@if [ -e test/test.lua ]; then lua test/test.lua; fi

tag :
	git tag -f v$(VERSION)

version :
	@echo $(NAME)-$(VERSION)

.PHONY : dist install test tag version
