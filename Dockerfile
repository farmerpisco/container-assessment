# Muliti-stage Dockerfile for Golang backend app
# Stage one: Build Stage
# Set a base image
FROM golang:1.25.5-alpine3.23 AS builder

# Use a LABEL instruction to add a metadata for contacts
LABEL "maintainer"="farmerpisco@gmail.com"

# Create working directory
WORKDIR /app

# Copy dependencies' file to the working directory
COPY application-code/go.mod application-code/go.sum ./

# Download the dependencies
RUN go mod download

# Copy the code file to the working directory 
COPY ./application-code .

# Build the app
RUN go build -o /app/muchtodo ./cmd/api

# Stage two: Runtime stage
FROM alpine:3.23

# Created environment variable for both group and user
ENV GN=goappgroup
ENV UN=goappuser

# Set working directory
WORKDIR /app

# Creat a non root user for security
RUN addgroup -S $GN && adduser -S -G $GN $UN

# Copy the app from the build stage
COPY --from=builder /app/muchtodo .

# change onwership of working directory
RUN chown -R $UN:$GN /app

# Switch to the new user
USER $UN

# Tell Docker what port the container listens on at runtime
EXPOSE 8080

# Add healthchecks
HEALTHCHECK --interval=30s --timeout=30s --retries=3  CMD wget -qO- http://localhost:8080/health || exit 1

# Add command to be executed when running a container
CMD ["./muchtodo"]
