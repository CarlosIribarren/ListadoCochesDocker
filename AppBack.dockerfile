############################################################
## Etapa : Checkout ########################################
############################################################
FROM alpine/git AS ETAPA_GIT
WORKDIR /code/
RUN git clone https://github.com/CarlosIribarren/ListadoCochesApi


############################################################
## Etapa : Package #########################################
############################################################

FROM maven:3.6.3-jdk-8-slim AS ETAPA_MAVEN
WORKDIR /build/
COPY --from=ETAPA_GIT /code/ListadoCochesApi/pom.xml /build/
COPY --from=ETAPA_GIT /code/ListadoCochesApi/src /build/src/
RUN mvn -Dmaven.test.skip=true package

############################################################
## Etapa : Ejecutar ########################################
############################################################


FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=ETAPA_MAVEN /build/target/ListadoCochesApi-exec.jar /app/
ENTRYPOINT ["java", "-jar", "ListadoCochesApi-exec.jar"]


# Crear imagen
# ------------
#  docker image build --no-cache -t listado-coches-api .

# Crear container
# ---------------
#  docker run -p 8081:8081 listado-coches-api

# Probar
# ------
# http://localhost:8081/api/coche/search/findByFechaMatriculacionBetween?inicio=2000-01-01&fin=2020-01-01&page=0size=25sortid,asc