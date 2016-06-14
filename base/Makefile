.PHONY: default image

# docs image
DOCS_IMAGE := "docker.waylay.io:5000/waylay/docs"

default: image

image:
	docker build -t "$(DOCS_IMAGE)" .
