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
    useFactory: (configService: ConfigService) => {
      const connectionUrl = configService.get<string>("database.url");
      const pool = new Pool({
        connectionString: connectionUrl,
      });

      return drizzle(pool, { schema, logger: false });
    },
  },
];
