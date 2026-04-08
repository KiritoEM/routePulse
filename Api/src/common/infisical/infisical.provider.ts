/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-return */
import { ConfigService } from "@nestjs/config";
import { InfisicalSDK } from "@infisical/sdk";

export const infisicalProvider = [
  {
    provide: "INFISICAL_CLIENT",
    inject: [ConfigService],
    useFactory: async (configService: ConfigService) => {
      const client = new InfisicalSDK({
        siteUrl: "https://eu.infisical.com",
      });

      const clientId = configService.get<string>(
        "infisical.clientId",
      ) as string;
      const clientSecret = configService.get<string>(
        "infisical.clientSecret",
      ) as string;

      try {
        await client.auth().universalAuth.login({
          clientId,
          clientSecret,
        });

        return client;
      } catch (error) {
        console.error("Infisical auth failed:", error);
        throw error; // Re-throw to fail startup clearly
      }
    },
  },
];
