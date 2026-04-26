/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { ValidationPipe, VersioningType } from "@nestjs/common";
import morgan from "morgan";
import { PRODUCTION_AUTHORIZED_HOSTS } from "./core/constants/cors-constants";
import { AllExceptionsFilter } from "./core/configs/allexceptions.filter";
import { urlencoded, json } from "express";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableVersioning({
    type: VersioningType.URI,
  });

  app.use(json({ limit: "45mb" }));
  app.use(urlencoded({ extended: true, limit: "45mb" }));

  app.setGlobalPrefix("v1/api");

  app.useGlobalFilters(new AllExceptionsFilter());

  app.getHttpAdapter().getInstance().set("trust proxy", 1);

  app.enableCors({
    origin: "*",
    credentials: true,
  });

  app.use(morgan("dev"));

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  await app.listen(process.env.PORT ?? 3000, "0.0.0.0", () => {
    console.log(
      `Server running on port http://localhost:${process.env.PORT ?? 3000}`,
    );
  });
}
bootstrap();
