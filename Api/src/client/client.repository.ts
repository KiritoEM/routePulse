// client.repository.ts
import { Inject, Injectable } from "@nestjs/common";
import { and, eq, ilike, sql } from "drizzle-orm";
import { CreateClientSchema } from "./types";
import { Client, clients } from "src/common/drizzle/schemas";
import * as drizzleProvider from "src/common/drizzle/drizzle.provider";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";

@Injectable()
export class ClientRepository {
  constructor(
    @Inject(DRIZZLE_PROVIDER_KEY)
    private readonly db: drizzleProvider.DrizzleDB,
  ) {}

  async create(data: CreateClientSchema): Promise<Client | null> {
    const result = await this.db.insert(clients).values(data).returning();
    return result[0] ?? null;
  }

  async findById(userId: string, clientId: string): Promise<Client | null> {
    const result = await this.db
      .select()
      .from(clients)
      .where(
        and(
          eq(clients.id, clientId),
          eq(clients.userId, userId),
          eq(clients.isDeleted, false),
        ),
      )
      .limit(1);
    return result[0] ?? null;
  }

  async searchByName(userId: string, name: string): Promise<Client[]> {
    return this.db
      .select()
      .from(clients)
      .where(
        and(
          eq(clients.userId, userId),
          ilike(clients.name, `%${name}%`),
          eq(clients.isDeleted, false),
        ),
      );
  }
}
