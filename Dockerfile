#---------------------------
# stage 1
#---------------------------

FROM beevelop/android-nodejs:latest as build-stage

#---------------------------

RUN mkdir -p /app

COPY . ./app

WORKDIR /app

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

WORKDIR /app/android

#---------------------------

RUN cp -R licenses /opt/android/

RUN chmod +x gradlew

RUN ./gradlew assembleDebug --debug

#---------------------------
# stage 2
#---------------------------

FROM nginx:alpine

# FROM scratch

COPY --from=build-stage /app/android/app/build/outputs/apk/debug/app-debug.apk /

