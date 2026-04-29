// client.repository.ts
import { Inject, Injectable } from "@nestjs/common";
import { and, eq, ilike, SQL, sql } from "drizzle-orm";
import { CreateClientSchema, UpdateClientSchema } from "./types";
import { Client, clients } from "src/common/drizzle/schemas";
import * as drizzleProvider from "src/common/drizzle/drizzle.provider";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";

@Injectable()
export class ClientRepository {
  private commonConditions: SQL[] = [eq(clients.isDeleted, false)];

  constructor(
    @Inject(DRIZZLE_PROVIDER_KEY)
    private readonly db: drizzleProvider.DrizzleDB,
  ) {}

  async create(data: CreateClientSchema): Promise<Client | null> {
    const result = await this.db.insert(clients).values(data).returning();

    return result[0] ?? null;
  }

  async findAll(userId: string): Promise<Client[]> {
    return await this.db.query.clients.findMany({
      where: and(eq(clients.userId, userId), ...this.commonConditions),
    });
  }

  async findById(userId: string, clientId: string): Promise<Client | null> {
    return (
      (await this.db.query.clients.findFirst({
        where: and(
          eq(clients.id, clientId),
          eq(clients.userId, userId),
          ...this.commonConditions,
        ),
      })) ?? null
    );
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

  async update(
    clientId: string,
    data: UpdateClientSchema,
  ): Promise<Client | null> {
    const result = await this.db
      .update(clients)
      .set(data)
      .where(eq(clients.id, clientId))
      .returning();

    return result[0] ?? null;
  }
}
