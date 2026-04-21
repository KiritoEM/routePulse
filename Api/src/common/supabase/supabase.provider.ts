import { ConfigService } from "@nestjs/config";
import { createClient } from "@supabase/supabase-js";
import { SUPABASE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";

export const supabaseProvider = [
  {
    provide: SUPABASE_PROVIDER_KEY,
    inject: [ConfigService],
    useFactory: (configService: ConfigService) => {
      return createClient(
        configService.get<string>("supabase.url") as string,
        configService.get<string>("supabase.key") as string,
        {
          auth: {
            autoRefreshToken: true,
            persistSession: false,
            detectSessionInUrl: false,
          },
          db: {
            schema: "public",
          },
        },
      );
    },
  },
];
