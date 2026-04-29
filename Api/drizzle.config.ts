import type { Config } from "drizzle-kit";
import "dotenv/config";

export default {
  schema: "./src/common/drizzle/schemas/**/*.ts",
  out: "./src/common/drizzle/migrations",
  dialect: "postgresql",
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
  migrations: {
    prefix: "timestamp",
  },
  verbose: true,
  strict: true,
} satisfies Config;
