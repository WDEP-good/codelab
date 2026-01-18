FROM golang:1.20 AS claat-builder

WORKDIR /build

COPY claat/ ./claat/

WORKDIR /build/claat
RUN go mod download && \
    mkdir -p bin && \
    go build -o bin/claat .

FROM golang:1.20 AS converter

COPY --from=claat-builder /build/claat/bin/claat /usr/local/bin/claat

WORKDIR /workspace

COPY .env* ./

RUN SOURCE_DIR="codelabs" && \
    if [ -f ".env" ]; then \
      ENV_SOURCE=$(grep "^CODELAB_SOURCE_DIR=" .env 2>/dev/null | cut -d'=' -f2 | tr -d '\r' | tr -d '"' | tr -d "'" || echo ""); \
      if [ -n "$ENV_SOURCE" ]; then \
        SOURCE_DIR="$ENV_SOURCE"; \
      fi; \
    fi && \
    echo "$SOURCE_DIR" > /tmp/source_dir.txt

COPY . /workspace/

RUN mkdir -p /workspace/site/codelabs

RUN SOURCE_DIR=$(cat /tmp/source_dir.txt) && \
    echo "Source directory: $SOURCE_DIR" && \
    ls -la "/workspace/$SOURCE_DIR"

RUN SOURCE_DIR=$(cat /tmp/source_dir.txt) && \
    find "$SOURCE_DIR" -name "*.md" -type f

RUN SOURCE_DIR=$(cat /tmp/source_dir.txt) && \
    for md_file in $(find "$SOURCE_DIR" -name "*.md" -type f); do \
      echo "Converting: $md_file" && \
      claat export -o /workspace/site/codelabs "$md_file"; \
    done

RUN ls -la /workspace/site/codelabs/

FROM node:10.24.1

WORKDIR /app

RUN npm install -g bower gulp

COPY site/package*.json ./

RUN npm install

COPY --from=converter /workspace/site/ ./

RUN ls -la ./codelabs/

COPY --from=converter /workspace/.env* ./ 

RUN if [ -f bower.json ] && [ ! -d "app/bower_components" ]; then \
      bower install --allow-root; \
    fi

EXPOSE 8000

CMD ["gulp", "serve", "--codelabs-dir=./codelabs"]
