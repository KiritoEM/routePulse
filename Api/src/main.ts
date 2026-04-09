/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { ValidationPipe, VersioningType } from "@nestjs/common";
import morgan from "morgan";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { PRODUCTION_AUTHORIZED_HOSTS } from "./core/constants/cors-constants";
import { AllExceptionsFilter } from "./core/configs/allexceptions.filter";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableVersioning({
    type: VersioningType.URI,
  });

  app.setGlobalPrefix("v1/api");

  app.useGlobalFilters(new AllExceptionsFilter());

  app.getHttpAdapter().getInstance().set("trust proxy", 1);

  app.enableCors({
    origin:
      process.env.NODE_ENV === "production" ? PRODUCTION_AUTHORIZED_HOSTS : "*",
    credentials: true,
  });

  app.use(morgan("dev"));

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  //Swagger configurations
  const swaggerConfig = new DocumentBuilder()
    .setTitle("API E-manasa")
    .setDescription("API de la plateforme E-manasa")
    .setVersion("1.0")
    .addBearerAuth(
      {
        type: "http",
        scheme: "bearer",
        bearerFormat: "JWT",
        name: "JWT",
        description: "Enter le JWT token",
        in: "header",
      },
      "JWT-auth",
    )
    .build();

  const documentFactory = () =>
    SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup("api/docs", app, documentFactory);

  await app.listen(process.env.PORT ?? 3000, "0.0.0.0", () => {
    console.log(
      `Server running on port http://localhost:${process.env.PORT ?? 3000}`,
    );
  });
}
bootstrap();
