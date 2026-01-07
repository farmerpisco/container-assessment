# Set a base image
FROM golang:1.25.5-alpine AS builder

# Use a LABEL instruction to add a metadata for contacts
LABEL "maintainer"="farmerpisco@gmail.com"

# Created environment variable for both group and user
ENV GN=dockergroup
ENV UN=dockeruser

# Creat a non root user for security
RUN apk update && \
    addgroup -S $GN && adduser -S -G $GN $UN

# Switch to the new user
USER $UN

# set working directory
WORKDIR /app

# Copy dependencies' file to the working directory
COPY go.mod go.sum ./

# Download the dependencies
RUN go mod download

# Copy the code file to the working directory 
COPY . .

# Build the app
RUN go build -o /app/muchtodo ./cmd/api

# Start a multibuild stage to ensure image lightweight
FROM alpine:latest

# Get certifictes to support https protocol
RUN apk --no-cache add ca-certificates wget

# Set working directory
WORKDIR /app

# Copy the app from the previous stage
COPY --from=builder /app/muchtodo .

# Add execution permission to the app
RUN chmod +x ./muchtodo

# Tell Docker what port the container listens on at runtime for
EXPOSE 8080

# Add healthchecks
HEALTHCHECK --interval=30s --timeout=30s --retries=3  CMD wget -qO- http://localhost:8080/health || exit 1

# Add command to be executed when running a container
CMD ["./muchtodo"]
