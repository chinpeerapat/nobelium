FROM node:14-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:14-alpine AS builder
WORKDIR /app
COPY . .
COPY --from=deps /app/node_modules ./node_modules

ARG NOTION_PAGE_ID
ENV NOTION_PAGE_ID=$NOTION_PAGE_ID
RUN yarn build

ENV NODE_ENV production
EXPOSE 3000
CMD ["yarn", "start"]
