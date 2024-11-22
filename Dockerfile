FROM node:20 AS builder
RUN mkdir /app
ADD https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip /tmp/backend.zip
WORKDIR /app
RUN unzip /tmp/backend.zip && \
    npm install

FROM node:20.18.0-alpine3.20
EXPOSE 8080
ENV DB_HOST="mysql"
RUN addgroup -S expense && adduser -S expense -G expense && \
    mkdir -p /app && \
    chown -R expense:expense /app
WORKDIR /app
COPY --from=builder /app /app
USER expense
CMD [ "node", "index.js" ]


# FROM node:20 AS builder
# EXPOSE 8080
# ENV DB_HOST="mysql"
# RUN useradd expense 
# RUN mkdir /app
# ADD https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip /tmp/backend.zip
# WORKDIR /app
# RUN unzip /tmp/backend.zip
# RUN npm install
# CMD [ "node", "index.js" ]

