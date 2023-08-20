include ../.env

IMAGE=${DOCKER_USERNAME}/${APPLICATION_NAME}_${IMAGE_NAME}

build:
	docker build -t ${IMAGE} .

push:
	docker push ${IMAGE}