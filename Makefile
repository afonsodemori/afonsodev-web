-include .env

# development

dev: build
	npx nuxt dev --port=$(PORT) --host=0.0.0.0

build:
	npx nuxt build

preview: generate-production
	npx nuxt preview

clean:
	rm -rf .nuxt/ .output/ .wrangler/ dist/ node_modules/ i18n/locales/generated/*
	npm ci
	./bin/prebuild.sh

import-resume:
	./bin/resume-html.sh

CI_COMMIT_SHORT_SHA ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
generate-preview: import-resume
	npx nuxt build --dotenv=.env.preview
	@echo "{\"status\":\"up\", \"service\":\"afonsodev-web\", \"env\":\"preview\", \"commit\":\"$(CI_COMMIT_SHORT_SHA)\", \"built_at\":\"$$(date -u +'%Y-%m-%dT%H:%M:%SZ')\"}" > ./.output/public/health.json

generate-production: import-resume
	npx nuxt build --dotenv=.env.production
	@echo "{\"status\":\"up\", \"service\":\"afonsodev-web\", \"env\":\"production\", \"commit\":\"$(CI_COMMIT_SHORT_SHA)\", \"built_at\":\"$$(date -u +'%Y-%m-%dT%H:%M:%SZ')\"}" > ./.output/public/health.json

deploy-preview: clean generate-preview
	npx wrangler deploy --env=preview

deploy-production: clean generate-production
	npx wrangler --env=production deploy

# docker

CI_COMMIT_SHORT_SHA ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
docker-build: clean generate
	@echo "Building Docker image $(IMAGE_NAME)"
	rm -f ./.output/public/_redirects
	/bin/bash ./bin/nginx-redirections.sh
	@echo "{\"status\":\"up\", \"service\":\"afonsodev-web\", \"commit\":\"$(CI_COMMIT_SHORT_SHA)\", \"built_at\":\"$$(date -u +'%Y-%m-%dT%H:%M:%SZ')\"}" > .output/public/health.json
	@ARGS=; \
	for tag in $$(echo "$(IMAGE_TAGS)" | tr ',' ' '); do \
		echo "Adding tag: $$tag"; \
		ARGS="$$ARGS --tag $(IMAGE_NAME):$$tag"; \
	done; \
	docker buildx build . \
		--platform linux/amd64,linux/arm64 \
		--file docker/Dockerfile.production \
		$$ARGS
	rm ./docker/nginx-redirections.conf

docker-run:
	docker run -p 8080:8080 $(IMAGE_NAME)

docker-push: docker-build
	@for tag in $$(echo "$(IMAGE_TAGS)" | tr ',' ' '); do \
		echo "Pushing tag: $$tag"; \
		docker push $(IMAGE_NAME):$$tag; \
	done
