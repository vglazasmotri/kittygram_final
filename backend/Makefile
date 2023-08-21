IMAGE_NAME ?= backend
WSGI_APPLICATION=kittygram_backend.wsgi

ifneq (,$(wildcard ../Makefile))
    include ../Makefile
endif

run_%:
	gunicorn --bind 0.0.0.0:$* ${WSGI_APPLICATION}