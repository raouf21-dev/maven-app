FROM amazoncorretto:8-alpine3.17-jre

EXPOSE 8080

COPY ./target/java-maven-*.jar /user/app/

WORKDIR /user/app/

# ENTRYPOINT [ "java", "-jar", "java-maven-app-1.0-SNAPSHOT.jar" ]

CMD java -jar java-maven-*.jar