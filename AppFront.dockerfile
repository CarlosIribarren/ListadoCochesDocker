############################################################
## Etapa : Checkout ########################################
############################################################
FROM alpine/git AS ETAPA_GIT
WORKDIR /code/
RUN git clone https://github.com/CarlosIribarren/ListadoCochesApi
RUN git clone https://github.com/CarlosIribarren/ListadoCochesWEB

############################################################
## Etapa : Package #########################################
############################################################

# Se utiliza una imagen maven oficial entera para utilizar la carpeta m2
FROM maven:3.6.3-jdk-8 AS ETAPA_MAVEN

# ListadoCochesApi
COPY  --from=ETAPA_GIT /code/ListadoCochesApi/pom.xml /build/ListadoCochesApi/
COPY  --from=ETAPA_GIT /code/ListadoCochesApi/src /build/ListadoCochesApi/src/
WORKDIR /build/ListadoCochesApi/
RUN mvn -Dmaven.test.skip=true install

# ListadoCochesWEB
COPY  --from=ETAPA_GIT /code/ListadoCochesWEB/pom.xml /build/ListadoCochesWEB/
COPY  --from=ETAPA_GIT /code/ListadoCochesWEB/src /build/ListadoCochesWEB/src/
WORKDIR /build/ListadoCochesWEB/
RUN mvn -Dmaven.test.skip=true package 

############################################################
## Etapa : Ejecutar ########################################
############################################################

FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=ETAPA_MAVEN /build/ListadoCochesWEB/target/ListadoCochesWEB.war /app/
ENTRYPOINT ["java", "-jar", "ListadoCochesWEB.war"]

# Crear imagen
# ------------
#  docker image build --no-cache -t listado-coches-front .

# Crear container
# ---------------
#  docker run -p 8080:8080 listado-coches-front

# Probar
# ------
# http://localhost:8080/