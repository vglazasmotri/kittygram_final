IMAGE_NAME ?= backend
BACKEND_PORT=9000
WSGI_APPLICATION=kittygram_backend.wsgi

ifneq (,$(wildcard ../Makefile))
    include ../Makefile
endif

run:
	gunicorn --bind 0.0.0.0:${BACKEND_PORT} ${WSGI_APPLICATION}