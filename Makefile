NAME = aerobatic/deployer
VERSION = 0.1.0

build:
	docker build --rm=false -t $(NAME):$(VERSION) .

interactive:
	docker run -i -t $(NAME):$(VERSION) bin/bash

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

clean_untagged:
	@docker rmi --force $$(docker images | grep '^<none>' | awk '{print $$3}')

clean_images:
	docker rmi aerobatic/deployer:latest aerobatic/deployer:$(VERSION) || true
