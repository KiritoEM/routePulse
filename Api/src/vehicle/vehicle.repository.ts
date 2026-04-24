// vehicle.repository.ts
import { Inject, Injectable } from "@nestjs/common";
import { and, eq, ilike } from "drizzle-orm";
import { Vehicle, vehicles } from "src/common/drizzle/schemas";
import * as drizzleProvider from "src/common/drizzle/drizzle.provider";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";
import { CreateVehicleSchema } from "./types";

@Injectable()
export class VehicleRepository {
  constructor(
    @Inject(DRIZZLE_PROVIDER_KEY)
    private readonly db: drizzleProvider.DrizzleDB,
  ) {}

  async create(data: CreateVehicleSchema): Promise<Vehicle | null> {
    const result = await this.db.insert(vehicles).values(data).returning();
    return result[0] ?? null;
  }

  async findAll(userId: string): Promise<Vehicle[]> {
    return this.db
      .select()
      .from(vehicles)
      .where(and(eq(vehicles.userId, userId)));
  }
}
