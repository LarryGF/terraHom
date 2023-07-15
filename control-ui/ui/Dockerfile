# syntax=docker/dockerfile:1.2
FROM node:14 as frontend-build
ENV HOST 0
WORKDIR /usr/src/app
ADD ./ ./
RUN  yarn install

FROM node:14
WORKDIR /usr/src/app
COPY --from=frontend-build /usr/src/app/package*.json ./
COPY --from=frontend-build /usr/src/app/yarn* ./
RUN  yarn install
COPY --from=frontend-build /usr/src/app/*.js ./
COPY --from=frontend-build /usr/src/app/.nuxt ./.nuxt
COPY --from=frontend-build /usr/src/app/static ./static
EXPOSE 3000

CMD ["yarn", "start"]
