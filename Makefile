NAME = aerobatic-deployer
VERSION = 0.1.3
REGISTRY = 677305290892.dkr.ecr.us-west-2.amazonaws.com

build:
	chmod 700 install-cli.sh
	docker build --rm=false -t $(NAME):$(VERSION) .

interactive:
	docker run -i -t $(NAME):$(VERSION) bin/bash

tag_registry:
	docker tag $(NAME):$(VERSION) $(REGISTRY)/$(NAME):$(VERSION)

push:
	docker push $(REGISTRY)/$(NAME):$(VERSION)

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

clean_untagged:
	@docker rmi --force $$(docker images | grep '^<none>' | awk '{print $$3}')

clean_images:
	docker rmi $(NAME):latest $(NAME):$(VERSION) || true

login:
	aws ecr get-login --region us-west-2
