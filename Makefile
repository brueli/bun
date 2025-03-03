ALL_GO_MOD_DIRS := $(shell find . -type f -name 'go.mod' -exec dirname {} \; | sort)

test:
	set -e; for dir in $(ALL_GO_MOD_DIRS); do \
	  echo "go test in $${dir}"; \
	  (cd "$${dir}" && \
	    go test && \
	    env GOOS=linux GOARCH=386 go test && \
	    go vet); \
	done

go_mod_tidy:
	go get -u && go mod tidy -go=1.17
	set -e; for dir in $(ALL_GO_MOD_DIRS); do \
	  echo "go mod tidy in $${dir}"; \
	  (cd "$${dir}" && \
	    go get -u ./... && \
	    go mod tidy -go=1.17); \
	done

fmt:
	gofmt -w -s ./
	goimports -w  -local github.com/uptrace/bun ./
