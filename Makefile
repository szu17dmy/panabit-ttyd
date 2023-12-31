.PHONY: all

GOCMD=go
GOBUILD=$(GOCMD) build
GOTEST=$(GOCMD) test
GOCLEAN=$(GOCMD) clean

DIST_DIR=./build/dist
PACKAGE=./build/panabit-ttyd.tar.gz
TTYD=./static/bin/ttyd
TTYD_URL=https://github.com/tsl0922/ttyd/releases/download/1.7.4/ttyd.aarch64

all: clean build package

clean:
	rm -rf $(DIST_DIR)

build: build-ctl build-cgi build-daemon build-hooks

build-ctl:
	GOOS=linux GOARCH=arm64 $(GOBUILD) -o $(DIST_DIR)/appctl -v ./cmd
build-cgi:
	GOOS=linux GOARCH=arm64 $(GOBUILD) -o $(DIST_DIR)/web/cgi/webmain -v ./cmd/cgi
	GOOS=linux GOARCH=arm64 $(GOBUILD) -o $(DIST_DIR)/web/cgi/api -v ./cmd/cgi/api
build-daemon:
	GOOS=linux GOARCH=arm64 $(GOBUILD) -o $(DIST_DIR)/daemon -v ./cmd/daemon
build-hooks:
	GOOS=linux GOARCH=arm64 $(GOBUILD) -o $(DIST_DIR)/afterinstall -v ./cmd/hooks/postinstall

package: $(TTYD)
	cp -r ./static/* $(DIST_DIR)
	chmod +x $(DIST_DIR)/appctrl
	tar -czvf $(PACKAGE) -C $(DIST_DIR) --exclude='.gitkeep' .

$(TTYD):
	wget -O $(TTYD) $(TTYD_URL)
