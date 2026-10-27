FROM node:22-alpine

RUN npm install --global juice \
    && npm cache clean --force

WORKDIR /data
USER node

ENTRYPOINT ["juice"]
CMD ["--help"]
