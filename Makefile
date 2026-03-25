-include .env

# development

dev: build
	npx nuxt dev

build:
	npx nuxt build

clean:
	rm -rf .nuxt/ .output/ .wrangler/ dist/ node_modules/ i18n/locales/generated/*
	npm ci
	/bin/bash bin/prebuild.sh

import-resume:
	bash bin/resume-html.sh

generate: import-resume
	npx nuxt generate

preview: generate
	npx wrangler dev

deploy-preview: clean generate
	npx wrangler versions upload --env=preview --preview-alias=preview
	rm -rf dist/

deploy-production: clean generate
	npx wrangler deploy --env=production
	rm -rf dist/

# cloudflare tunnel

tunnel-init:
	cloudflared tunnel login
	cloudflared tunnel create afonsodev-web || true
	cloudflared tunnel route dns --overwrite-dns afonsodev-web dev-afonsodev-web.afonso.dev

tunnel-run:
	cloudflared tunnel --config=.devcontainer/cloudflared/config.yml run afonsodev-web

# docker

docker-build: clean generate
	@echo "Building Docker image $(IMAGE_NAME)"
	rm -f ./.output/public/_redirects
	/bin/bash ./bin/nginx-redirections.sh
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
