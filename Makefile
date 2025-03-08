
IMAGE_NAME = cpld-toolchain
DOCKER_USER = dinoboards
VERSION = 1.0.0

all: build

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME):$(VERSION) -t $(IMAGE_NAME):latest .

# # Push the Docker image to Docker Hub
# .PHONY: push
push:
	docker tag $(IMAGE_NAME):$(VERSION) $(DOCKER_USER)/$(IMAGE_NAME):$(VERSION)
	docker tag $(IMAGE_NAME):latest $(DOCKER_USER)/$(IMAGE_NAME):latest
	docker push $(DOCKER_USER)/$(IMAGE_NAME):$(VERSION)
	docker push $(DOCKER_USER)/$(IMAGE_NAME):latest
