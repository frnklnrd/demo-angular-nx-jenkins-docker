# stage 1

FROM beevelop/nodejs:latest as compile-stage

RUN mkdir -p /app

COPY . ./app

WORKDIR /app

RUN npm install -g nx

RUN npm install

RUN nx build

RUN npx cap copy

RUN npx cap sync

RUN npx cap update

# stage 2

FROM beevelop/android:latest as build-stage

RUN mkdir -p /app/android

COPY --from=compile-stage /app/android /app/android

WORKDIR /app/android

RUN cp -R licenses /opt/android/

RUN chmod +x gradlew

RUN ./gradlew assembleDebug --debug

# stage 3

FROM nginx:alpine

# FROM scratch

COPY --from=build-stage /app/android/app/build/outputs/apk/debug/app-debug.apk /

