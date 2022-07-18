#stage 1

FROM beevelop/cordova:latest as build-node

RUN mkdir -p /app

WORKDIR /app

COPY . .

COPY ./.env.prod ./.env

RUN cp -R licenses /opt/android/

# RUN npm install -g @angular/cli

RUN npm install -g nx

RUN npm install

RUN nx build

# RUN npx cap add android

RUN npx cap copy

RUN npx cap sync

RUN npx cap update

WORKDIR /app/android

RUN chmod +x gradlew

RUN ./gradlew assembleDebug

#stage 2

FROM scratch

COPY --from=build-node /app/android/app/build/outputs/apk /
