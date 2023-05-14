DOCKER_REGESTRY ?= docker.io
DOCKER_IMAGE_NAME ?= lanolin25/kube-hw
DOCKER_IMAGE_VERSION ?= 1.0.0

DOCKER_IMAGE_FILL ?= ${DOCKER_REGESTRY}/${DOCKER_IMAGE_NAME}

.PHONE: check_pandoc gen_doc

check_pandoc:
	pandoc --version

gen_doc: check_pandoc docs/*.md
	pandoc docs/*.md --to=markdown -o README.md

docker_build: 
	docker build -t ${DOCKER_IMAGE_FILL}:latest .

docker_run: 
	docker run --name test --rm -it -p 8080:8000 ${DOCKER_IMAGE_FILL}:latest

docker_push:
	docker tag ${DOCKER_IMAGE_FILL}:latest ${DOCKER_IMAGE_FILL}:${DOCKER_IMAGE_VERSION}
	docker push ${DOCKER_IMAGE_FILL}:${DOCKER_IMAGE_VERSION}
	docker push ${DOCKER_IMAGE_FILL}:latest