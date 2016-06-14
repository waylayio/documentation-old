.PHONY: default clean clone preview build

DOCS_IMAGE := "docker.waylay.io:5000/waylay/docs:internal"

default: clean clone image build

clean:
	rm -rf projects site

image:
	docker build -t $(DOCS_IMAGE) .

clone:
	git clone --depth 1 git@github.com:waylayio/device-gateway.git projects/device-gateway
	git clone --depth 1 git@github.com:waylayio/hoard.git projects/hoard

preview: clean clone image
	docker run -it --rm -p 8000:8000 $(DOCS_IMAGE) serve -a 0.0.0.0:8000

build:
	docker run -it --rm -v `pwd`/site:/mkdocs/site $(DOCS_IMAGE) build
