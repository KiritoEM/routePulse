import { registerAs } from "@nestjs/config";

export default registerAs("infisical", () => ({
  clientId: process.env.INFISICAL_CLIENT_ID,
  projectId: process.env.INFISICAL_PROJECT_ID,
  clientSecret: process.env.INFISICAL_CLIENT_SECRET,
}));
