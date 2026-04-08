/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { InfisicalSDK, Secret } from "@infisical/sdk";
import { Inject, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { INFISICAL_PROVIDER_KEY } from "src/core/constants/dependencies-constants";

@Injectable()
export class InfisicalService {
  private projectId: string = "";
  private environment: string = "";

  constructor(
    @Inject(INFISICAL_PROVIDER_KEY) private readonly client: InfisicalSDK,
    private readonly configService: ConfigService,
  ) {
    this.environment =
      this.configService.get<string>("NODE_ENV") === "production"
        ? "prod"
        : "dev";
    this.projectId = this.configService.get<string>(
      "infisical.projectId",
    ) as string;
  }

  // create a secret
  async createSecret(name: string, value: string) {
    await this.client.secrets().createSecret(name, {
      environment: this.environment,
      secretValue: value,
      projectId: this.projectId,
    });
  }

  // get a secret
  async getSecret(name: string): Promise<Secret> {
    return await this.client.secrets().getSecret({
      environment: this.environment,
      secretName: name,
      projectId: this.projectId,
    });
  }
}
