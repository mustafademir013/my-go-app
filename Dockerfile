# Builder image
FROM golang:latest AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files to the working directory
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o app .

# Final image
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the binary from the builder image
COPY --from=builder /app/app .

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["./app"]
