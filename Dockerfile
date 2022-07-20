# version 1.0.0

#---------------------------
# stage 1
#---------------------------

FROM beevelop/nodejs:latest as compile-stage

#---------------------------

RUN mkdir -p /app

WORKDIR /app

COPY . .

#---------------------------

RUN npm install -g nx

RUN npm install

#---------------------------

RUN nx build

#---------------------------

RUN npx cap copy

RUN npx cap sync

RUN npx cap update

#---------------------------

FROM beevelop/android-nodejs:latest as build-stage

RUN mkdir -p /app/android

COPY --from=compile-stage /app /app

WORKDIR /app/android

#---------------------------

RUN cp -R licenses /opt/android/

RUN chmod +x gradlew

RUN ./gradlew assembleDebug

#---------------------------
# stage 3
#---------------------------

FROM nginx:alpine as final-stage

# FROM scratch

COPY --from=build-stage /app/android/app/build/outputs/apk/debug/app-debug.apk /

