import { ConfigService } from "@nestjs/config";
import { drizzle, NodePgDatabase } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import * as schema from "./schemas";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";

export type DrizzleDB = NodePgDatabase<typeof schema>;

export const drizzleProvider = [
  {
    provide: DRIZZLE_PROVIDER_KEY,
    inject: [ConfigService],
    useFactory: async (configService: ConfigService) => {
      const connectionUrl = configService.get<string>("database.url");
      const pool = new Pool({
        connectionString: connectionUrl,
      });

      try {
        const client = await pool.connect();
        client.release();
        console.log("✅ Database connected successfully, URL: ",connectionUrl);
      } catch (err) {
        console.error("❌ Database connection failed:", err.message);
        throw err; // stop app if DB has any issues
      }

      return drizzle(pool, { schema, logger: false });
    },
  },
];
