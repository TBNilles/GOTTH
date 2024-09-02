# Use the official Golang image as a parent image
FROM golang:alpine

# Set the working directory inside the container
WORKDIR /app

COPY . .

WORKDIR /app/static/vendor
RUN apk update && apk add --update nodejs-current npm && \
    npm install bootstrap@latest --save && \
    npm install jquery@latest --save && \
    npm install jquery-ui@latest --save

WORKDIR /app

RUN wget https://github.com/tailwindlabs/tailwindcss/releases/download/v3.4.10/tailwindcss-linux-x64 && \
    chmod +x tailwindcss-linux-x64 && \
    mv tailwindcss-linux-x64 tailwindcss

RUN go install github.com/swaggo/swag/cmd/swag@latest

# Install 'air' for live reloading
RUN go install github.com/air-verse/air@latest

RUN go mod tidy

# Expose port 9090 for the application
EXPOSE 9090

# Start 'air' for live reloading
CMD ["air"]
