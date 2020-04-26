include .env

TARGET_DIR = $(CURDIR)/target
BUILD_DIR  = $(TARGET_DIR)/build
PKG        = $(shell $(GO) list -m)
ALL        = $(PKG)/...

GO      = go
GOBUILD = $(GO) build -ldflags="-s -w"
GOCLEAN = $(GO) clean

GOTEST = $(GO) test -v \
	-covermode=atomic \
	-coverpkg=$(ALL) \
	-short \
	-coverprofile=$(TARGET_DIR)/coverage.out
GOVET = $(GO) vet

GOMOD = $(GO) mod

$(TARGET_DIR):
	mkdir -p $(TARGET_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

list: $(TARGET_DIR) $(BUILD_DIR)
	@echo TARGET_DIR: $(TARGET_DIR)
	@echo BUILD_DIR:  $(BUILD_DIR)
	@echo PKG:        $(PKG)

test: list
	$(GOTEST) $(ALL)
	$(GOVET)  $(ALL)

build: test
	GOOS=linux   $(GOBUILD) -o "$(BUILD_DIR)/dnd"      $(ALL)
	GOOS=darwin  $(GOBUILD) -o "$(BUILD_DIR)/dnd.drwn" $(ALL)
	GOOS=windows $(GOBUILD) -o "$(BUILD_DIR)/dnd.exe"  $(ALL)

deps:
	$(GOMOD) tidy

TAG ?= dev
docker:
	docker build -t $(DOCKER_REPO)dnd-backend:$(TAG) .

# For development only.
docker-run-dev: docker
	docker run \
		-p=$(TARGET_PORT):$(TARGET_PORT) \
		--env-file=.env \
		--name=dnd-backend \
		--rm \
		$(DOCKER_REPO)dnd-backend:$(TAG)